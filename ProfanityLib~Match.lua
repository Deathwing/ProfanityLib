--[[
ProfanityLib~Match.lua

Matching for user-supplied strings (character names, guild names,
last words).

  ProfanityLib:IsProfane("N1ggerHunter")  --> true, "nigger"
  ProfanityLib:IsProfane("Nïggér")        --> true, "nigger"
  ProfanityLib:Clean("gg")                --> true
  ProfanityLib:AddTerm("term", exact)

Matching folds accented Latin letters to ASCII ("ï" -> "i", "æ" -> "ae"),
folds leetspeak digits/symbols to letters, lowercases, and strips
everything that is not an ASCII letter before testing. Repeated characters
are deliberately NOT collapsed: folding "nigga" to "niga" makes it match
innocent real names such as "Brennigan" and "Siniganggang".

The wordlist ships separately in ProfanityLibData, together with the
corpus statistics that justify each term's substring/exact/dropped
placement. Without ProfanityLibData nothing matches (everything is
considered clean) apart from terms added via AddTerm.
--]]

local _pl = ProfanityLib and ProfanityLib.Internal ---@class _pl
if not _pl then return end

--- Runtime wordlists, rebuilt from ProfanityLibData whenever its loaded
--- version changes, plus the terms registered through AddTerm.
local state = ProfanityLib.State
state.added_terms = state.added_terms or {}
local substring_terms, exact_terms, exceptions
local merged_data_version
local function resolveTerms()
	local data = type(ProfanityLibData) == "table" and ProfanityLibData or nil
	local data_version = data and data.VERSION or false
	if substring_terms and merged_data_version == data_version then return end
	merged_data_version = data_version
	substring_terms, exact_terms, exceptions = {}, {}, {}
	if data then
		for _, term in ipairs(data.SUBSTRING_TERMS or {}) do
			substring_terms[#substring_terms + 1] = term
		end
		for term in pairs(data.EXACT_TERMS or {}) do
			exact_terms[term] = true
		end
		for _, word in ipairs(data.EXCEPTIONS or {}) do
			exceptions[#exceptions + 1] = word
		end
	end
	for _, added in ipairs(state.added_terms) do
		if added.exact then
			exact_terms[added.term] = true
		else
			substring_terms[#substring_terms + 1] = added.term
		end
	end
end

---Fold a string for matching: map accented Latin letters to ASCII,
---lowercase, apply leet substitutions, then strip everything that is not
---an ASCII letter.
---@param s string
---@return string
local function fold(s)
	s = s:gsub("[\195-\197][\128-\191]", _pl.DIACRITIC_MAP)
	s = s:lower()
	s = s:gsub("[013457%$@!]", _pl.LEET_MAP)
	return (s:gsub("[^a-z]", ""))
end
_pl.fold = fold

---Test a string for profanity.
---@param s string|nil
---@return boolean is_profane
---@return string|nil matched_term
function ProfanityLib:IsProfane(s)
	if type(s) ~= "string" or s == "" then return false, nil end
	resolveTerms()

	local folded = fold(s)
	if folded ~= "" then
		-- Remove benign words before the substring scan so
		-- "Badtherapist" cannot match "rapist".
		local scrubbed = folded
		for i = 1, #exceptions do
			scrubbed = scrubbed:gsub(exceptions[i], "")
		end
		for i = 1, #substring_terms do
			local term = substring_terms[i]
			if scrubbed:find(term, 1, true) then
				return true, term
			end
		end
	end

	-- Guild names and last words are multi-word, so exact terms are tested
	-- per word rather than against the whole folded string. Words keep
	-- high bytes ("Erlkönig" must stay one word, not "erlk" + "nig") and
	-- are folded so leetspeak cannot dodge the exact list.
	for w in s:gmatch("[%w%$@!\128-\255]+") do
		local fw = fold(w)
		if exact_terms[fw] then return true, fw end
	end
	if exact_terms[folded] then return true, folded end

	return false, nil
end

---Inverse of IsProfane, for readability at call sites.
---@param s string|nil
---@return boolean
function ProfanityLib:Clean(s)
	return not (self:IsProfane(s))
end

---Add a term at runtime.
---@param term string
---@param exact boolean|nil  match as a whole word only
function ProfanityLib:AddTerm(term, exact)
	if type(term) ~= "string" or term == "" then return end
	term = fold(term)
	if term == "" then return end
	state.added_terms[#state.added_terms + 1] = { term = term, exact = exact and true or false }
	merged_data_version = nil
end
