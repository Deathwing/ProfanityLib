--[[
ProfanityLib~Init.lua
--]]

local VERSION = 4

local lib = ProfanityLib
if lib and lib.VERSION and (lib.VERSION >= VERSION or not lib.Shutdown) then return end
if lib and lib.Shutdown then
	lib.Shutdown()
end
lib = lib or {}
ProfanityLib = lib

local internal = { frames = {}, cleanups = {}, stopped = false }
lib.VERSION = VERSION
lib.State = lib.State or {}
lib.Internal = internal

function lib.Shutdown()
	internal.stopped = true
	for _, cleanup in ipairs(internal.cleanups) do
		cleanup()
	end
	for _, frame in ipairs(internal.frames) do
		frame:UnregisterAllEvents()
		frame:SetScript("OnUpdate", nil)
		frame:Hide()
	end
end

function internal.createFrame(...)
	local frame = CreateFrame(...)
	internal.frames[#internal.frames + 1] = frame
	return frame
end

function internal.after(delay, callback)
	C_Timer.After(delay, function()
		if not internal.stopped then callback() end
	end)
end

function internal.newTicker(interval, callback, iterations)
	return C_Timer.NewTicker(interval, function(ticker)
		if internal.stopped then return ticker:Cancel() end
		callback(ticker)
	end, iterations)
end

function internal.newTimer(delay, callback)
	return C_Timer.NewTimer(delay, function(timer)
		if not internal.stopped then callback(timer) end
	end)
end

function internal.hookSecureFunc(...)
	local args = { ... }
	local callback = args[#args]
	args[#args] = function(...)
		if not internal.stopped then return callback(...) end
	end
	hooksecurefunc(unpack(args))
end

function internal.hookScript(frame, script, callback)
	frame:HookScript(script, function(...)
		if not internal.stopped then return callback(...) end
	end)
end

local _pl = internal ---@class _pl

--- Leetspeak substitutions applied before matching.
_pl.LEET_MAP = {
	["0"] = "o", ["1"] = "i", ["3"] = "e", ["4"] = "a",
	["5"] = "s", ["7"] = "t", ["$"] = "s", ["@"] = "a", ["!"] = "i",
}

--- Accented Latin letters folded to their ASCII base before matching, so
--- "Nïgger" and "Fàggot" cannot dodge the wordlist. Keys are the UTF-8
--- byte pairs of the Latin-1 Supplement (U+00C0-U+00FF) and Latin
--- Extended-A (U+0100-U+017F) letters; ligatures expand to two letters.
--- Anything outside these ranges (Cyrillic, CJK, ...) is left alone and
--- stripped by fold() as before.
_pl.DIACRITIC_MAP = {
	-- a: À Á Â Ã Ä Å à á â ã ä å Ā ā Ă ă Ą ą
	["\195\128"] = "a", ["\195\129"] = "a", ["\195\130"] = "a", ["\195\131"] = "a", ["\195\132"] = "a", ["\195\133"] = "a", ["\195\160"] = "a", ["\195\161"] = "a", ["\195\162"] = "a", ["\195\163"] = "a", ["\195\164"] = "a", ["\195\165"] = "a", ["\196\128"] = "a", ["\196\129"] = "a", ["\196\130"] = "a", ["\196\131"] = "a", ["\196\132"] = "a", ["\196\133"] = "a",
	-- ae: Æ æ
	["\195\134"] = "ae", ["\195\166"] = "ae",
	-- c: Ç ç Ć ć Ĉ ĉ Ċ ċ Č č
	["\195\135"] = "c", ["\195\167"] = "c", ["\196\134"] = "c", ["\196\135"] = "c", ["\196\136"] = "c", ["\196\137"] = "c", ["\196\138"] = "c", ["\196\139"] = "c", ["\196\140"] = "c", ["\196\141"] = "c",
	-- d: Ð ð Ď ď Đ đ
	["\195\144"] = "d", ["\195\176"] = "d", ["\196\142"] = "d", ["\196\143"] = "d", ["\196\144"] = "d", ["\196\145"] = "d",
	-- e: È É Ê Ë è é ê ë Ē ē Ĕ ĕ Ė ė Ę ę Ě ě
	["\195\136"] = "e", ["\195\137"] = "e", ["\195\138"] = "e", ["\195\139"] = "e", ["\195\168"] = "e", ["\195\169"] = "e", ["\195\170"] = "e", ["\195\171"] = "e", ["\196\146"] = "e", ["\196\147"] = "e", ["\196\148"] = "e", ["\196\149"] = "e", ["\196\150"] = "e", ["\196\151"] = "e", ["\196\152"] = "e", ["\196\153"] = "e", ["\196\154"] = "e", ["\196\155"] = "e",
	-- g: Ĝ ĝ Ğ ğ Ġ ġ Ģ ģ
	["\196\156"] = "g", ["\196\157"] = "g", ["\196\158"] = "g", ["\196\159"] = "g", ["\196\160"] = "g", ["\196\161"] = "g", ["\196\162"] = "g", ["\196\163"] = "g",
	-- h: Ĥ ĥ
	["\196\164"] = "h", ["\196\165"] = "h",
	-- i: Ì Í Î Ï ì í î ï Ĩ ĩ Ī ī Ĭ ĭ Į į İ ı
	["\195\140"] = "i", ["\195\141"] = "i", ["\195\142"] = "i", ["\195\143"] = "i", ["\195\172"] = "i", ["\195\173"] = "i", ["\195\174"] = "i", ["\195\175"] = "i", ["\196\168"] = "i", ["\196\169"] = "i", ["\196\170"] = "i", ["\196\171"] = "i", ["\196\172"] = "i", ["\196\173"] = "i", ["\196\174"] = "i", ["\196\175"] = "i", ["\196\176"] = "i", ["\196\177"] = "i",
	-- ij: Ĳ ĳ
	["\196\178"] = "ij", ["\196\179"] = "ij",
	-- j: Ĵ ĵ
	["\196\180"] = "j", ["\196\181"] = "j",
	-- k: Ķ ķ ĸ
	["\196\182"] = "k", ["\196\183"] = "k", ["\196\184"] = "k",
	-- l: Ĺ ĺ Ļ ļ Ľ ľ Ŀ ŀ Ł ł
	["\196\185"] = "l", ["\196\186"] = "l", ["\196\187"] = "l", ["\196\188"] = "l", ["\196\189"] = "l", ["\196\190"] = "l", ["\196\191"] = "l", ["\197\128"] = "l", ["\197\129"] = "l", ["\197\130"] = "l",
	-- n: Ñ ñ Ń ń Ņ ņ Ň ň ŉ
	["\195\145"] = "n", ["\195\177"] = "n", ["\197\131"] = "n", ["\197\132"] = "n", ["\197\133"] = "n", ["\197\134"] = "n", ["\197\135"] = "n", ["\197\136"] = "n", ["\197\137"] = "n",
	-- o: Ò Ó Ô Õ Ö Ø ò ó ô õ ö ø Ō ō Ŏ ŏ Ő ő
	["\195\146"] = "o", ["\195\147"] = "o", ["\195\148"] = "o", ["\195\149"] = "o", ["\195\150"] = "o", ["\195\152"] = "o", ["\195\178"] = "o", ["\195\179"] = "o", ["\195\180"] = "o", ["\195\181"] = "o", ["\195\182"] = "o", ["\195\184"] = "o", ["\197\140"] = "o", ["\197\141"] = "o", ["\197\142"] = "o", ["\197\143"] = "o", ["\197\144"] = "o", ["\197\145"] = "o",
	-- oe: Œ œ
	["\197\146"] = "oe", ["\197\147"] = "oe",
	-- r: Ŕ ŕ Ŗ ŗ Ř ř
	["\197\148"] = "r", ["\197\149"] = "r", ["\197\150"] = "r", ["\197\151"] = "r", ["\197\152"] = "r", ["\197\153"] = "r",
	-- s: Ś ś Ŝ ŝ Ş ş Š š ſ
	["\197\154"] = "s", ["\197\155"] = "s", ["\197\156"] = "s", ["\197\157"] = "s", ["\197\158"] = "s", ["\197\159"] = "s", ["\197\160"] = "s", ["\197\161"] = "s", ["\197\191"] = "s",
	-- ss: ß
	["\195\159"] = "ss",
	-- t: Ţ ţ Ť ť
	["\197\162"] = "t", ["\197\163"] = "t", ["\197\164"] = "t", ["\197\165"] = "t",
	-- th: Þ þ
	["\195\158"] = "th", ["\195\190"] = "th",
	-- u: Ù Ú Û Ü ù ú û ü Ũ ũ Ū ū Ŭ ŭ Ů ů Ű ű Ų ų
	["\195\153"] = "u", ["\195\154"] = "u", ["\195\155"] = "u", ["\195\156"] = "u", ["\195\185"] = "u", ["\195\186"] = "u", ["\195\187"] = "u", ["\195\188"] = "u", ["\197\168"] = "u", ["\197\169"] = "u", ["\197\170"] = "u", ["\197\171"] = "u", ["\197\172"] = "u", ["\197\173"] = "u", ["\197\174"] = "u", ["\197\175"] = "u", ["\197\176"] = "u", ["\197\177"] = "u", ["\197\178"] = "u", ["\197\179"] = "u",
	-- w: Ŵ ŵ
	["\197\180"] = "w", ["\197\181"] = "w",
	-- y: Ý ý ÿ Ŷ ŷ Ÿ
	["\195\157"] = "y", ["\195\189"] = "y", ["\195\191"] = "y", ["\197\182"] = "y", ["\197\183"] = "y", ["\197\184"] = "y",
	-- z: Ź ź Ż ż Ž ž
	["\197\185"] = "z", ["\197\186"] = "z", ["\197\187"] = "z", ["\197\188"] = "z", ["\197\189"] = "z", ["\197\190"] = "z",
}

-- Wordlists (SUBSTRING_TERMS, EXACT_TERMS, EXCEPTIONS) ship separately
-- in ProfanityLibData.
