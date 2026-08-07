--[[
ProfanityLib~Init.lua
--]]

local VERSION = 1

if ProfanityLib and (ProfanityLib.VERSION or 0) >= VERSION then return end

---@class ProfanityLib
---@field Internal _pl
ProfanityLib = { VERSION = VERSION, Internal = {} }

local _pl = ProfanityLib.Internal ---@class _pl

--- Leetspeak substitutions applied before matching.
_pl.LEET_MAP = {
	["0"] = "o", ["1"] = "i", ["3"] = "e", ["4"] = "a",
	["5"] = "s", ["7"] = "t", ["$"] = "s", ["@"] = "a", ["!"] = "i",
}

-- Wordlists (SUBSTRING_TERMS, EXACT_TERMS, EXCEPTIONS) ship separately
-- in ProfanityLibData.
