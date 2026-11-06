--[[--------------------------------------------------------------------------
	Lunar Shade - protected-file decryption (ChaCha20-Poly1305, RFC 8439)

	Protected Lunar Shade Lua files are stored as authenticated ciphertext:

	    "LSC1" | nonce (12 bytes) | ciphertext | Poly1305 tag (16 bytes)

	They are sealed at build time by tools/ls_build.py with a vetted library
	(OpenSSL, through Python "cryptography"), using a fresh random 96-bit nonce
	for every file. This file only OPENS them. It never encrypts anything, so
	the game never has to produce a nonce.

	Garry's Mod has no built-in cipher, so this is a straight pure-Lua
	implementation of the RFC 8439 AEAD for LuaJIT's `bit` library. It is
	checked at build time against the RFC 8439 test vectors and against
	OpenSSL (see tests/), and Crypt.SelfTest() / the console command
	lunar_shade_crypt_test repeat the known-answer tests inside the game.

	Decrypt(blob, path) checks the 128-bit Poly1305 tag over the header data,
	the file's path and the whole ciphertext FIRST. Plaintext is only produced
	when the tag is correct, so a modified, truncated, swapped or corrupted
	file, or a file sealed with another key, gives nil, reason - never garbage.

	LIMITS - read this: the key has to be on the player's computer for the
	game to read the files, so anyone who runs the addon can recover it and
	the Lua. This is tamper-evidence and light obfuscation, NOT secrecy. It
	keeps casual readers and modified or swapped files out; it cannot make
	Lua impossible to recover.
----------------------------------------------------------------------------]]

LunarShade = LunarShade or {}
LunarShade.Crypt = LunarShade.Crypt or {}
local Crypt = LunarShade.Crypt

Crypt.Scheme = "chacha20-poly1305"
Crypt.Format = 1

-- The 256-bit file key. Written by tools/ls_build.py for each build. Do not edit.
-- LS_CRYPT_KEY_BEGIN
local KEY = "\091\224\166\125\068\100\112\157\118\122\198\049\104\041\255\107\062\027\254\230\168\253\019\007\237\187\087\078\068\063\165\001"
-- LS_CRYPT_KEY_END

local MAGIC = "LSC1"
local NONCE_LEN, TAG_LEN = 12, 16
local HEADER_LEN = #MAGIC + NONCE_LEN
local AAD_PREFIX = "LunarShade/ChaCha20-Poly1305/1/"

local bit = rawget(_G, "bit")
local byte, char, sub, concat = string.byte, string.char, string.sub, table.concat
local floor = math.floor

if not bit then
	function Crypt.Decrypt() return nil, "the bit library is not available" end
	function Crypt.SelfTest() return false, "the bit library is not available" end
	return
end

local band, bor, bxor, rol, rshift, tobit = bit.band, bit.bor, bit.bxor, bit.rol, bit.rshift, bit.tobit

-- ChaCha20 ----------------------------------------------------------------------------------

local function word(s, i) -- little-endian 32-bit word at byte i (1-based), as a bit-library number
	local a, b, c, d = byte(s, i, i + 3)
	return tobit(a + b * 256 + c * 65536 + d * 16777216)
end

local function qr(a, b, c, d)
	a = tobit(a + b); d = rol(bxor(d, a), 16)
	c = tobit(c + d); b = rol(bxor(b, c), 12)
	a = tobit(a + b); d = rol(bxor(d, a), 8)
	c = tobit(c + d); b = rol(bxor(b, c), 7)
	return a, b, c, d
end

-- One 64-byte block as 16 words in `out` (1..16). kw: 8 key words, nw: 3 nonce words.
local function chacha_block(kw, counter, nw, out)
	local i0, i1, i2, i3 = 0x61707865, 0x3320646e, 0x79622d32, 0x6b206574
	local i4, i5, i6, i7, i8, i9, i10, i11 = kw[1], kw[2], kw[3], kw[4], kw[5], kw[6], kw[7], kw[8]
	local i12, i13, i14, i15 = tobit(counter), nw[1], nw[2], nw[3]
	local x0, x1, x2, x3, x4, x5, x6, x7 = i0, i1, i2, i3, i4, i5, i6, i7
	local x8, x9, x10, x11, x12, x13, x14, x15 = i8, i9, i10, i11, i12, i13, i14, i15
	for _ = 1, 10 do
		x0, x4, x8, x12 = qr(x0, x4, x8, x12)
		x1, x5, x9, x13 = qr(x1, x5, x9, x13)
		x2, x6, x10, x14 = qr(x2, x6, x10, x14)
		x3, x7, x11, x15 = qr(x3, x7, x11, x15)
		x0, x5, x10, x15 = qr(x0, x5, x10, x15)
		x1, x6, x11, x12 = qr(x1, x6, x11, x12)
		x2, x7, x8, x13 = qr(x2, x7, x8, x13)
		x3, x4, x9, x14 = qr(x3, x4, x9, x14)
	end
	out[1], out[2], out[3], out[4] = tobit(x0 + i0), tobit(x1 + i1), tobit(x2 + i2), tobit(x3 + i3)
	out[5], out[6], out[7], out[8] = tobit(x4 + i4), tobit(x5 + i5), tobit(x6 + i6), tobit(x7 + i7)
	out[9], out[10], out[11], out[12] = tobit(x8 + i8), tobit(x9 + i9), tobit(x10 + i10), tobit(x11 + i11)
	out[13], out[14], out[15], out[16] = tobit(x12 + i12), tobit(x13 + i13), tobit(x14 + i14), tobit(x15 + i15)
end

local function w2s(w) -- 32-bit word to 4 little-endian bytes
	return char(band(w, 255), band(rshift(w, 8), 255), band(rshift(w, 16), 255), rshift(w, 24))
end

local function key_words(key)
	local kw = {}
	for i = 0, 7 do kw[i + 1] = word(key, i * 4 + 1) end
	return kw
end

local function nonce_words(nonce)
	return { word(nonce, 1), word(nonce, 5), word(nonce, 9) }
end

-- XOR `data` with the ChaCha20 keystream starting at block `counter`.
local function chacha_xor(kw, nw, counter, data)
	local len = #data
	if len >= 0x40000000 then error("data too large") end
	local ks, out, n, pos = {}, {}, 0, 1
	while pos <= len do
		chacha_block(kw, counter, nw, ks)
		counter = counter + 1
		local parts = {}
		if len - pos + 1 >= 64 then
			for i = 0, 15 do
				local a, b, c, d = byte(data, pos + i * 4, pos + i * 4 + 3)
				parts[i + 1] = w2s(bxor(ks[i + 1], a + b * 256 + c * 65536 + d * 16777216))
			end
			pos = pos + 64
		else
			local rest = len - pos + 1
			local full = floor(rest / 4)
			for i = 0, full - 1 do
				local a, b, c, d = byte(data, pos + i * 4, pos + i * 4 + 3)
				parts[#parts + 1] = w2s(bxor(ks[i + 1], a + b * 256 + c * 65536 + d * 16777216))
			end
			local left = rest - full * 4
			if left > 0 then
				local ksb = w2s(ks[full + 1])
				local t = {}
				for j = 1, left do t[j] = char(bxor(byte(data, pos + full * 4 + j - 1), byte(ksb, j))) end
				parts[#parts + 1] = concat(t)
			end
			pos = len + 1
		end
		n = n + 1
		out[n] = concat(parts)
	end
	return concat(out)
end

local function chacha_keystream_32(kw, counter, nw) -- first 32 bytes of a block (the Poly1305 key)
	local ks = {}
	chacha_block(kw, counter, nw, ks)
	local t = {}
	for i = 1, 8 do t[i] = w2s(ks[i]) end
	return concat(t)
end

-- Poly1305 ----------------------------------------------------------------------------------
-- 130-bit arithmetic in ten 13-bit limbs (the layout TweetNaCl uses). Every intermediate value
-- stays far below 2^53, so Lua doubles hold it exactly.

local LIMB = 8192 -- 2^13

local function limbs_from_bytes(b) -- b[1..17] little-endian bytes (17th = bits 128..135) to 10 limbs
	local t = {}
	for i = 0, 9 do
		local p = 13 * i
		local k = floor(p / 8) + 1
		local v = b[k] + b[k + 1] * 256 + b[k + 2] * 65536
		t[i + 1] = band(rshift(v, p % 8), 8191)
	end
	return t
end

local function carry_chain(h) -- propagate carries through limbs 1..10, returns the carry out of limb 10
	local c = 0
	for i = 1, 10 do
		local v = h[i] + c
		c = floor(v / LIMB)
		h[i] = v - c * LIMB
	end
	return c
end

-- key: 32-byte one-time key (r || s). Returns the 16-byte tag of msg.
local function poly1305(key, msg)
	local rb = { byte(key, 1, 16) }
	rb[4], rb[8], rb[12], rb[16] = band(rb[4], 15), band(rb[8], 15), band(rb[12], 15), band(rb[16], 15)
	rb[5], rb[9], rb[13] = band(rb[5], 252), band(rb[9], 252), band(rb[13], 252)
	rb[17] = 0
	local r = limbs_from_bytes(rb)
	local r5 = {}
	for i = 1, 10 do r5[i] = r[i] * 5 end

	local h = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local d = {}
	local mb = {}
	local len = #msg
	local pos = 1
	while pos <= len do
		local n = len - pos + 1
		if n >= 16 then
			mb[1], mb[2], mb[3], mb[4], mb[5], mb[6], mb[7], mb[8], mb[9], mb[10], mb[11], mb[12], mb[13], mb[14], mb[15], mb[16] = byte(msg, pos, pos + 15)
			mb[17] = 1 -- the 2^128 bit
		else
			for i = 1, 16 do mb[i] = 0 end
			for i = 1, n do mb[i] = byte(msg, pos + i - 1) end
			mb[n + 1] = 1 -- 0x01 terminator; no 2^128 bit on a partial block
			mb[17] = 0
		end
		local m = limbs_from_bytes(mb)
		for i = 1, 10 do h[i] = h[i] + m[i] end

		for i = 1, 10 do
			local acc = 0
			for j = 1, 10 do
				if j <= i then acc = acc + h[j] * r[i - j + 1]
				else acc = acc + h[j] * r5[i - j + 11] end
			end
			d[i] = acc
		end
		local c = 0
		for i = 1, 10 do
			local v = d[i] + c
			c = floor(v / LIMB)
			h[i] = v - c * LIMB
		end
		local v = h[1] + c * 5
		c = floor(v / LIMB)
		h[1] = v - c * LIMB
		h[2] = h[2] + c
		pos = pos + 16
	end

	-- full reduction modulo 2^130 - 5
	local top = carry_chain(h)
	while top > 0 do
		h[1] = h[1] + top * 5
		top = carry_chain(h)
	end
	-- now h < 2^130 with every limb < 2^13; subtract p if h >= p (i.e. h + 5 >= 2^130)
	local g = {}
	for i = 1, 10 do g[i] = h[i] end
	g[1] = g[1] + 5
	if carry_chain(g) == 1 then h = g end

	-- tag = (h + s) mod 2^128, little-endian
	local hb, acc, nb = {}, 0, 0
	for i = 1, 10 do
		acc = acc + h[i] * 2 ^ nb
		nb = nb + 13
		while nb >= 8 do
			hb[#hb + 1] = acc % 256
			acc = floor(acc / 256)
			nb = nb - 8
		end
	end
	local sb = { byte(key, 17, 32) }
	local out, carry = {}, 0
	for i = 1, 16 do
		local v = hb[i] + sb[i] + carry
		carry = v >= 256 and 1 or 0
		out[i] = char(v % 256)
	end
	return concat(out)
end

-- AEAD (RFC 8439 section 2.8) -----------------------------------------------------------------

local function le64(n)
	local lo = n % 4294967296
	local hi = floor(n / 4294967296)
	return w2s(tobit(lo)) .. w2s(tobit(hi))
end

local function pad16(s)
	local r = #s % 16
	return r == 0 and "" or string.rep("\0", 16 - r)
end

local function ct_equal(a, b)
	if #a ~= #b then return false end
	local diff = 0
	for i = 1, #a do diff = bor(diff, bxor(byte(a, i), byte(b, i))) end
	return diff == 0
end

-- Verifies the tag FIRST; returns the plaintext only if it is correct.
local function aead_open(key, nonce, aad, ct, tag)
	local kw, nw = key_words(key), nonce_words(nonce)
	local otk = chacha_keystream_32(kw, 0, nw)
	local mac_data = aad .. pad16(aad) .. ct .. pad16(ct) .. le64(#aad) .. le64(#ct)
	if not ct_equal(poly1305(otk, mac_data), tag) then return nil, "authentication failed" end
	return chacha_xor(kw, nw, 1, ct)
end

-- Public API ----------------------------------------------------------------------------------

local function key_ok()
	if type(KEY) ~= "string" or #KEY ~= 32 then return false end
	return KEY ~= string.rep("\0", 32) -- the unprovisioned placeholder
end

-- Opens a protected file. `path` is the file's name as Lunar Shade lists it (for example
-- "lunar_shade/cl_ui.lua"); it is part of the authenticated data, so a file cannot be
-- swapped for another. Returns plaintext, or nil and a reason.
function Crypt.Decrypt(blob, path)
	if type(blob) ~= "string" then return nil, "no data" end
	if type(path) ~= "string" or path == "" then return nil, "no file name given" end
	if not key_ok() then return nil, "no valid key is installed in sh_crypt.lua" end
	if #blob < HEADER_LEN + TAG_LEN then return nil, "file is too short to be a protected Lunar Shade file" end
	if sub(blob, 1, #MAGIC) ~= MAGIC then return nil, "not a protected Lunar Shade file (wrong header)" end
	local nonce = sub(blob, #MAGIC + 1, HEADER_LEN)
	local tag = sub(blob, -TAG_LEN)
	local ct = sub(blob, HEADER_LEN + 1, #blob - TAG_LEN)
	local aad = AAD_PREFIX .. path
	local ok, res, why = pcall(aead_open, KEY, nonce, aad, ct, tag)
	if not ok then return nil, "decryption error: " .. tostring(res) end
	if res == nil then return nil, why .. " (the file was modified, damaged or sealed with a different key)" end
	return res
end

-- Known-answer tests from RFC 8439, run on the game's own Lua. Returns true, or false, reason.
local function unhex(h) return (h:gsub("%x%x", function(x) return char(tonumber(x, 16)) end)) end

function Crypt.SelfTest()
	local ok, a, b = pcall(function()
		-- RFC 8439 2.3.2: ChaCha20 block function
		local kw = key_words(unhex("000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"))
		local nw = nonce_words(unhex("000000090000004a00000000"))
		local blk = {}
		chacha_block(kw, 1, nw, blk)
		local got = {}
		for i = 1, 16 do got[i] = w2s(blk[i]) end
		if concat(got):sub(1, 16) ~= unhex("10f1e7e4d13b5915500fdd1fa32071c4") then return false, "ChaCha20 block test failed" end
		-- RFC 8439 2.5.2: Poly1305 (a 34 byte message: a partial last block)
		local t = poly1305(unhex("85d6be7857556d337f4452fe42d506a80103808afb0db2fd4abff6af4149f51b"), "Cryptographic Forum Research Group")
		if t ~= unhex("a8061dc1305136c6c22b8baf0c0127a9") then return false, "Poly1305 test failed" end
		-- RFC 8439 2.8.2: AEAD, must open correctly...
		local key = unhex("808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f")
		local nonce = unhex("070000004041424344454647")
		local aad = unhex("50515253c0c1c2c3c4c5c6c7")
		local ct = unhex("d31a8d34648e60db7b86afbc53ef7ec2a4aded51296e08fea9e2b5a736ee62d63dbea45e8ca9671282fafb69da92728b1a71de0a9e060b2905d6a5b67ecd3b3692ddbd7f2d778b8c9803aee328091b58fab324e4fad675945585808b4831d7bc3ff4def08e4b7a9de576d26586cec64b6116")
		local tag = unhex("1ae10b594f09e26a7e902ecbd0600691")
		local pt = aead_open(key, nonce, aad, ct, tag)
		if pt ~= "Ladies and Gentlemen of the class of '99: If I could offer you only one tip for the future, sunscreen would be it." then
			return false, "AEAD open test failed"
		end
		-- ...and must reject a flipped ciphertext bit, a flipped tag bit and a wrong key
		local bad = char(bxor(byte(ct, 1), 1)) .. ct:sub(2)
		if aead_open(key, nonce, aad, bad, tag) ~= nil then return false, "modified ciphertext was accepted" end
		local badtag = char(bxor(byte(tag, 16), 128))
		if aead_open(key, nonce, aad, ct, tag:sub(1, 15) .. badtag) ~= nil then return false, "modified tag was accepted" end
		if aead_open(key:sub(1, 31) .. "\0", nonce, aad, ct, tag) ~= nil then return false, "wrong key was accepted" end
		return true
	end)
	if not ok then return false, "self-test error: " .. tostring(a) end
	return a, b
end

if concommand and concommand.Add then
	pcall(concommand.Add, "lunar_shade_crypt_test", function()
		local ok, why = Crypt.SelfTest()
		MsgC(Color(157, 125, 255), "[Lunar Shade] ", Color(255, 255, 255),
			ok and "file-protection self-test passed (ChaCha20-Poly1305, RFC 8439 test vectors).\n"
			or ("file-protection self-test FAILED: " .. tostring(why) .. "\n"))
	end)
end
