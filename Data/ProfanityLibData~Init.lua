--[[
ProfanityLibData~Init.lua
--]]

local VERSION = 3

if ProfanityLibData and (ProfanityLibData.VERSION or 0) >= VERSION then return end

---@class ProfanityLibData
---@field Internal _pld
ProfanityLibData = { VERSION = VERSION, Internal = {} }
