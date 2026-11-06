--[[--------------------------------------------------------------------------
	Lunar Shade - signed release manifest check (client)

	Every official release carries lua/lunar_shade/sh_manifest.lua: a list of every
	release file (path, size, SHA-256) signed by the author's PRIVATE key, which is
	never part of the addon. This file holds only the matching PUBLIC key and checks:

	  1. the manifest signature (RSA-3072, PKCS#1 v1.5, SHA-256) is valid,
	  2. the manifest is for this version,
	  3. every listed file is present and has the listed hash,
	  4. no unexpected files sit in Lunar Shade's own folders.

	FAIL CLOSED: if the check does not end in "verified" (tampered, missing or
	unexpected files, bad signature, or the check could not run at all), the loader
	(autorun/zz_lunar_shade.lua) does not load any Lunar Shade feature and writes a
	marker file, data/lunar_shade_locked.txt, so the main menu part stays off too.
	It only ever switches Lunar Shade itself off. It never disables, removes, blocks or
	changes Garry's Mod or any other addon, and never changes a console variable.
	It sends nothing over the network.

	Files in the addon's .zip that Garry's Mod does not load (README, LICENSE, installers,
	addon.json) are only visible when Lunar Shade sits in a normal addons folder; for a
	Workshop (.gma) install they are skipped, not counted as errors. The command-line
	tool ls_release.py checks the complete download.

	See what it found:  lunar_shade_verify
----------------------------------------------------------------------------]]

LunarShade = LunarShade or {}
local LS = LunarShade
local V = LS.Verify or {}
LS.Verify = V

-- The author's PUBLIC key. Written by ls_release.py keygen. Do not edit.
-- LS_PUBKEY_BEGIN
V.PublicKey = { bits = 3072, e = 65537,
	n = "d8a34fdc66d07522e94875a46cd9940673a987e97da5b72f5a82b32b16f7379c516fc49eddfd9f1a6fb656d2984e11ef0240db2d83ac97d02058a6ac2465a4fd3f2816fa109ff656357db882312615934a0bd5c5cb2d4a9d72e529f697fcf6d8cc620b6764c103a766901322fa12c5f02207487cc974e802e21b94215bf9778c8af21e99c491fedee66ed0f19277a52386137f147be2c6178b7e0b7502ff7b58f5e09949bbc2cba1fb288eaf4ed11e11f2dd6358316e75621acd981c2f22f3ab59a94010ca73f236f02aad829fd2f7c020da14824b833e1bc6e89099a73ef59d48ac750d79788609e3becc5df0a1d5dbb6648af8f75faf2f899ec2b2d92d31c8b1b25f9c748cc7317a01211a0cabb6cba7d9de9f876e24174bf2b93ee83e2720c046b55a57bd60155f0aa273138e754ac20dd18b71b82d2789a3c1ba7ab7fca8effbb6608b8c881594e575e381d1d2f7d5eadc9811e5916cb28d1ff2e986441c39399c981c8247f1566a9a906a55e28276546fb282cd65a49063e283c3e1176f",
	rr = "2a2930e38b7c97d83bbb11dfe7e527f98a3a66d95ba87ff627d302f31e6ad5c956e61bf359e7381034cc16fe87b1810cee9b5849d3263fda53c78823baa1cd012c0e94b161bf1a746e67a5d0e0eb9bb1f99575702d6167882b213d9b8a27491f6cdb492a9d826a1e26e102806fab062cd8052dae8592fbfb415521d9ebff56e3e316a57975a208a84f90d86fa9e664278a23c92ff53afcb495f32a200ac93c82be85b5f00b3299bf4be373117ec3a7854a00040e16f0a6b68995d12309577a877e5e09aa24bd27966bd350387e8df9af4e37b94f154f85a20a7a3b38d2c2262f90b81031ca34ee15c1d253141a9b2fe879a7d89b158ab33bc363f3338ab6e4c5c5a5d72f61768e8ed26ae2026ead2f478718f388973a7913347437fda0756a54be9d2ced607fe4b6c91cc57abba17eee2dba2d7711581f74202ece98e10399d24a38073a26b9d039f17dd8f52608f205760c1a2eb85f61055488a9cf4f3e84151aca712f1579eac2f99324285fa5e414d03657eb2d94d11a2c8ff7a4f07f35cc",
	n0 = 9558129 }
-- LS_PUBKEY_END

local floor = math.floor
local BASE = 16777216   -- 2^24: one "limb"; products of two limbs stay exact in a double
local LIMB_HEX = 6

V.Result = V.Result or { State = "not run", Problems = {}, Notes = {}, Checked = 0, Skipped = 0 }

-- Big numbers: arrays of 24-bit limbs, least significant first ---------------------------

local function hex_to_limbs(h)
	local pad = (-#h) % LIMB_HEX
	if pad > 0 then h = string.rep("0", pad) .. h end
	local t, i = {}, #h
	while i >= 1 do
		t[#t + 1] = tonumber(string.sub(h, i - LIMB_HEX + 1, i), 16)
		i = i - LIMB_HEX
	end
	return t
end

local function limbs_to_hex(t, k)
	local out = {}
	for i = k, 1, -1 do out[#out + 1] = string.format("%06x", t[i]) end
	return table.concat(out)
end

local function cmp(a, b, k)
	for i = k, 1, -1 do
		local x, y = a[i] or 0, b[i] or 0
		if x ~= y then return x > y and 1 or -1 end
	end
	return 0
end

-- Montgomery product a*b*R^-1 mod n (R = BASE^k), CIOS method; a, b < n.
local function montmul(a, b, n, k, n0)
	local t = {}
	for i = 1, k + 2 do t[i] = 0 end
	for i = 1, k do
		local bi = b[i]
		local c = 0
		for j = 1, k do
			local s = t[j] + a[j] * bi + c
			c = floor(s / BASE)
			t[j] = s - c * BASE
		end
		local s = t[k + 1] + c
		c = floor(s / BASE)
		t[k + 1] = s - c * BASE
		t[k + 2] = c
		local m = (t[1] * n0) % BASE
		s = t[1] + m * n[1]
		c = floor(s / BASE)
		for j = 2, k do
			s = t[j] + m * n[j] + c
			c = floor(s / BASE)
			t[j - 1] = s - c * BASE
		end
		s = t[k + 1] + c
		c = floor(s / BASE)
		t[k] = s - c * BASE
		t[k + 1] = t[k + 2] + c
	end
	local sub = t[k + 1] > 0 or cmp(t, n, k) >= 0
	if sub then
		local borrow = 0
		for j = 1, k do
			local d = t[j] - n[j] - borrow
			if d < 0 then d = d + BASE; borrow = 1 else borrow = 0 end
			t[j] = d
		end
	end
	t[k + 1], t[k + 2] = nil, nil
	return t
end

local SHA256_PREFIX = "3031300d060960864801650304020105000420" -- DigestInfo for SHA-256

-- Loads and sanity-checks a public key table { bits, e, n, rr, n0 } of the kind written by
-- ls_release.py keygen. Any module that has a signed-by-the-author value to check (the release
-- manifest, the status/license reply, ...) can carry its own such table and pass it in here;
-- none of them need to see or store a private key, and a key used for one purpose cannot be
-- replayed to forge the other.
local function load_key(pk)
	if type(pk) ~= "table" or type(pk.n) ~= "string" or type(pk.rr) ~= "string" then return nil, "no public key" end
	if pk.e ~= 65537 then return nil, "unsupported public exponent" end
	if type(pk.bits) ~= "number" or pk.bits < 2048 or pk.bits % 24 ~= 0 then return nil, "unsupported key size" end
	if not pk.n:find("^%x+$") or #pk.n ~= pk.bits / 4 then return nil, "malformed public key" end
	if not pk.rr:find("^%x+$") then return nil, "malformed public key" end
	local k = pk.bits / 24
	local n, rr = hex_to_limbs(pk.n), hex_to_limbs(pk.rr)
	if #n ~= k or #rr > k or n[1] % 2 == 0 then return nil, "malformed public key" end
	if type(pk.n0) ~= "number" or (pk.n0 * n[1] + 1) % BASE ~= 0 then return nil, "public key constants do not match" end
	for i = #rr + 1, k do rr[i] = 0 end
	return { n = n, rr = rr, k = k, n0 = pk.n0, bits = pk.bits }
end
V.LoadKey = load_key

-- true if sig_hex is a valid RSASSA-PKCS1-v1_5 / SHA-256 signature of digest_hex under pubkey
-- (a table shaped like V.PublicKey; defaults to V.PublicKey, the release-manifest key); else
-- false, reason.
function V.RSAVerify(sig_hex, digest_hex, pubkey)
	local key, why = load_key(pubkey or V.PublicKey)
	if not key then return false, why, true end
	local k = key.k
	if type(sig_hex) ~= "string" or #sig_hex ~= k * LIMB_HEX or not sig_hex:find("^%x+$") then
		return false, "bad signature format"
	end
	local s = hex_to_limbs(sig_hex)
	if cmp(s, key.n, k) >= 0 then return false, "bad signature" end

	local one = { 1 }
	for i = 2, k do one[i] = 0 end
	local sm = montmul(s, key.rr, key.n, k, key.n0) -- s in Montgomery form
	local x = sm
	for _ = 1, 16 do x = montmul(x, x, key.n, k, key.n0) end -- s^(2^16)
	x = montmul(x, sm, key.n, k, key.n0)                      -- s^(2^16 + 1) = s^65537
	x = montmul(x, one, key.n, k, key.n0)                     -- out of Montgomery form

	local em = limbs_to_hex(x, k)
	local padlen = key.bits / 8 - 3 - #SHA256_PREFIX / 2 - 32
	local want = "0001" .. string.rep("ff", padlen) .. "00" .. SHA256_PREFIX .. string.lower(digest_hex)
	if em ~= want then return false, "bad signature" end
	return true
end

-- Manifest --------------------------------------------------------------------------------

local function safe_path(p)
	if type(p) ~= "string" or p == "" or #p > 200 then return false end
	if not p:find("^[%w_%.%-/]+$") then return false end
	for part in string.gmatch(p, "[^/]*") do
		if part == "." or part == ".." then return false end
	end
	if p:find("//", 1, true) or p:sub(1, 1) == "/" or p:sub(-1) == "/" then return false end
	return true
end

-- Returns { version = "x.y.z", files = { {path=,hash=,size=,scope=}, ... } } or nil, reason
function V.ParseManifest(text)
	if type(text) ~= "string" then return nil, "manifest text missing" end
	local lines = {}
	for line in string.gmatch(text, "[^\n]+") do lines[#lines + 1] = line end
	if lines[1] ~= "LUNAR SHADE RELEASE MANIFEST 1" then return nil, "unknown manifest format" end
	local version = (lines[2] or ""):match("^version (%d+%.%d+%.%d+)$")
	local count = tonumber((lines[3] or ""):match("^files (%d+)$"))
	if not version or not count then return nil, "manifest header is malformed" end
	local files, seen = {}, {}
	for i = 4, #lines do
		local hash, size, scope, path = lines[i]:match("^(%x+) (%d+) ([rp]) (%S+)$")
		if not hash or #hash ~= 64 or not safe_path(path) then return nil, "manifest line " .. i .. " is malformed" end
		local low = string.lower(path)
		if seen[low] then return nil, "manifest lists " .. path .. " twice" end
		seen[low] = true
		files[#files + 1] = { path = path, hash = string.lower(hash), size = tonumber(size), scope = scope }
	end
	if #files ~= count then return nil, "manifest file count does not match" end
	return { version = version, files = files }
end

-- Reading files ---------------------------------------------------------------------------

local function read_runtime(path)
	if string.sub(path, 1, 4) == "lua/" then return file.Read(string.sub(path, 5), "LUA") end
	return file.Read(path, "GAME")
end

local function list_files(dir, spath, prefix, out, depth)
	if depth > 8 then return end
	local files, dirs = file.Find(dir .. "/*", spath)
	for _, f in ipairs(files or {}) do out[#out + 1] = prefix .. dir .. "/" .. f end
	for _, d in ipairs(dirs or {}) do list_files(dir .. "/" .. d, spath, prefix, out, depth + 1) end
end

local function find_loose_root()
	local _, dirs = file.Find("addons/*", "GAME")
	for _, d in ipairs(dirs or {}) do
		if file.Exists("addons/" .. d .. "/lua/autorun/zz_lunar_shade.lua", "GAME") then return "addons/" .. d end
	end
end

local function add(res, text)
	for _, p in ipairs(res.Problems) do if p == text then return end end
	res.Problems[#res.Problems + 1] = text
end

local function check_one(res, entry, bytes, label)
	if bytes == nil then
		add(res, "missing file: " .. label)
	elseif #bytes ~= entry.size or string.lower(util.SHA256(bytes)) ~= entry.hash then
		add(res, "changed file: " .. label)
	else
		return true
	end
	return false
end

local function run()
	local res = { State = "failed", Problems = {}, Notes = {}, Checked = 0, Skipped = 0, Version = LS.Version }

	local m = LS.ReleaseManifest
	if not m then pcall(include, "lunar_shade/sh_manifest.lua"); m = LS.ReleaseManifest end
	if type(m) ~= "table" or type(m.text) ~= "string" or type(m.sig) ~= "string" then
		add(res, "signed manifest (lunar_shade/sh_manifest.lua) is missing or unreadable")
		return res
	end

	local ok, why, internal = V.RSAVerify(m.sig, util.SHA256(m.text))
	if not ok then
		if internal then
			res.State = "unverified"
			add(res, "could not check the signature: " .. tostring(why))
		else
			add(res, "manifest signature is not valid (" .. tostring(why) .. "): this is not an official signed release")
		end
		return res
	end

	local man, err = V.ParseManifest(m.text)
	if not man then add(res, "manifest unreadable: " .. tostring(err)); return res end
	if man.version ~= LS.Version then
		add(res, "manifest is for v" .. man.version .. " but the addon says v" .. tostring(LS.Version))
		return res
	end

	local known = {}
	for _, e in ipairs(man.files) do known[string.lower(e.path)] = e end
	known["lua/lunar_shade/sh_manifest.lua"] = true -- the signed manifest itself

	-- Files Garry's Mod actually loads (the copy that wins the search path)
	for _, e in ipairs(man.files) do
		if e.scope == "r" then
			res.Checked = res.Checked + 1
			check_one(res, e, read_runtime(e.path), e.path)
		end
	end

	-- Unexpected files inside Lunar Shade's own folders
	local seen = {}
	list_files("lunar_shade", "LUA", "lua/", seen, 0)
	list_files("lunar_shade_menu", "LUA", "lua/", seen, 0)
	list_files("materials/lunar_shade", "GAME", "", seen, 0)
	for _, p in ipairs(seen) do
		if not known[string.lower(p)] then add(res, "unexpected file: " .. p) end
	end

	-- The rest of the download (README, LICENSE, installers, addon.json), when Lunar Shade
	-- sits in a normal addons folder. Code and assets were checked above, where they load from.
	local root = find_loose_root()
	if root then
		for _, e in ipairs(man.files) do
			if e.scope == "p" then
				res.Checked = res.Checked + 1
				check_one(res, e, file.Read(root .. "/" .. e.path, "GAME"), root .. "/" .. e.path)
			end
		end
		local all = {}
		list_files(root, "GAME", "", all, 0)
		for _, p in ipairs(all) do
			local rel = string.sub(p, #root + 2)
			local low = string.lower(rel)
			local scanned = low:find("^lua/lunar_shade/") or low:find("^lua/lunar_shade_menu/") or low:find("^materials/lunar_shade/")
			if not scanned and not known[low] then add(res, "unexpected file: " .. p) end
		end
	else
		for _, e in ipairs(man.files) do if e.scope == "p" then res.Skipped = res.Skipped + 1 end end
		if res.Skipped > 0 then
			res.Notes[#res.Notes + 1] = res.Skipped .. " download-only files (README, LICENSE, installers) are not visible in this install type and were not checked"
		end
	end

	res.State = (#res.Problems == 0) and "verified" or "failed"
	return res
end

function V.Run()
	local ok, res = pcall(run)
	if not ok then
		res = { State = "unverified", Problems = { "the check itself hit an error: " .. tostring(res) }, Notes = {}, Checked = 0, Skipped = 0 }
	end
	V.Result = res
	return res
end

-- Reporting ---------------------------------------------------------------------------------

local PURPLE, WHITE, WARN = Color(157, 125, 255), Color(255, 255, 255), Color(255, 150, 120)

local function say(col, text) MsgC(PURPLE, "[Lunar Shade] ", col or WHITE, text, "\n") end

local function hint(res)
	for _, p in ipairs(res.Problems) do
		if p:find("lua/lunar_shade_menu/", 1, true) or p:find("sh_presets.lua", 1, true) or p:find("sh_crypt.lua", 1, true) then
			return "If you updated Lunar Shade, run Install-MainMenu again: the main menu uses its own copy of some files."
		end
	end
end

function V.Report(full)
	local res = V.Result
	if res.State == "verified" then
		if full then
			say(nil, "release check: verified. " .. res.Checked .. " files match the signed manifest for v" .. tostring(res.Version) .. ".")
			for _, n in ipairs(res.Notes) do say(nil, n) end
		end
		return
	end
	local head = (res.State == "unverified") and "release check: could not be completed." or "release check: this copy does not match the signed official release."
	say(WARN, head .. " Lunar Shade switches itself off; Garry's Mod and your other addons are not affected.")
	local limit = full and 40 or 3
	for i, p in ipairs(res.Problems) do
		if i > limit then say(WARN, "  ... and " .. (#res.Problems - limit) .. " more (run lunar_shade_verify)"); break end
		say(WARN, "  - " .. p)
	end
	local h = hint(res)
	if h then say(WARN, h) end
	say(nil, "If you did not change it yourself, download Lunar Shade again from the official page.")
	if full then for _, n in ipairs(res.Notes) do say(nil, n) end end
end

function V.RunAtLoad()
	V.Run()
	V.Report(false) -- silent when everything is fine
end

concommand.Add("lunar_shade_verify", function()
	V.Run()
	V.Report(true)
	local verified = V.Result.State == "verified"
	if not verified and not LS.Locked then
		-- Features are already loaded this session: they stay until the game restarts,
		-- but the next start will be locked (and so will the main menu part).
		pcall(file.Write, "lunar_shade_locked.txt", "release check failed while running")
		say(WARN, "Lunar Shade will stay switched off from the next start of the game until this is fixed.")
	elseif verified and LS.Locked then
		pcall(file.Delete, "lunar_shade_locked.txt")
		say(nil, "This copy now matches the signed release. Restart the game to switch Lunar Shade back on.")
	end
end)
