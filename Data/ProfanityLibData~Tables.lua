--[[
ProfanityLibData~Tables.lua

The wordlist. Terms are stored pre-folded (lowercase ASCII letters only —
see fold() in ProfanityLib~Match): matching folds the input the same way,
so a term containing a digit or symbol would never match.

Every term was validated against a corpus of 808,940 real character names
and 17,205 guild names extracted from the death databases; the only strings
flagged are genuinely offensive (78 of 826,145). Candidate terms that
collided with legitimate names were demoted to EXACT_TERMS or dropped:

  heeb   -> Pheebe, Cheebamon, Heebiejeebee   (54 hits, exact only)
  yid    -> Sayid, Druyid, Mayidie            (57 hits, exact only)
  dyke   -> Gwendyke, Dikkvandyke, Bodykeeper (15 hits, exact only)
  chink  -> Schinkenpelz, Palatschinki        (26 hits, exact only)
  gook   -> Gobblegook, Gookydooky            (15 hits, exact only)
  kike   -> Zarakikenpa, Punkike, Kiketta     (14 hits, exact only)
  nazi   -> Athanazia, Abunazir, Specnazik    (11 hits, exact only)
  paki   -> Papakiwi, Elpakito, Freepakistan  (34 hits, exact only)
  pedo   -> Pedometer, Empedokles, Torpedo    (70 hits, dropped — the
            explicit pedophile/paedo forms below carry the load)
  wog    -> Hornswoggle, Gortwog              (128 hits, exact only)
  abbo   -> Abbott, Gabbo, Backstabbob        (54 hits, exact only)
  sambo  -> Sambosako, Bosambosa              (26 hits, exact only)
  spic   -> Spiceblock, Grasspicker           (302 hits, dropped)
  molester -> Gnomolester, Demolester         (12 hits, only child/kid
            compounds are listed)
  darkie -> Strongdarkie, Darkiecow           (kept exact only)
  injun  -> Injunction, Deathinjune           (14 hits, exact only)
  squaw  -> Squawkers, Sasquawktch            (exact only)
  beaner -> Jellybeaner, Toebeaners           (exact only)
  raghead -> Craghead                         (exact only)
  boong  -> Oongaboonga, Baboong              (22 hits, exact only)
  honky/honkey -> Chonky, Chonkyhonks, Donkeyhonkey (28 hits, dropped)
  retard -> Retardes (name)                   (only "retarded" is listed)
  troon  -> Astroonuts, Zitroone, Destroone   (10 hits, dropped)
  ladyboy / futanari / slut / cunt / rape / bitch -> lewd rather than
            slurs, and collide (Bodycøunt, Grapesurgeon, 182 slut hits);
            out of scope for this list

SUBSTRING_TERMS match anywhere in the folded string. EXACT_TERMS only
match a whole word (or the whole folded string). EXCEPTIONS are benign
words removed from the folded string before the substring scan
("Badtherapist" must not match "rapist").
--]]

local _pld = ProfanityLibData.Internal
if not _pld then return end

--#region API

--- Terms matched anywhere in the folded string.
ProfanityLibData.SUBSTRING_TERMS = {
	-- anti-Black
	"nigger", "nigga", "nigguh", "niglet", "nigglet", "nignog",
	"negrosucks", "jigabo", "jiggabo", "junglebunny", "porchmonkey",
	"spearchucker", "tarbaby", "pickaninny", "picaninny", "sheboon",
	"golliwog", "groid", "coalburner", "dindunuffin", "dindunothin",
	"shitskin",
	-- anti-Asian
	"chingchong", "slanteye", "zipperhead",
	-- anti-Latino
	"wetback",
	-- anti-Arab / anti-Muslim
	"towelhead", "cameljockey", "goatfucker", "mudslime",
	-- anti-Indian
	"currymuncher", "pajeet",
	-- antisemitic / Nazi
	"gasjew", "ovenjew", "jewburner", "heilhitler", "hitler",
	"holocaust", "gaschamber", "auschwitz", "zyklonb", "swastika",
	"siegheil", "whitepower", "kukluxklan",
	-- anti-LGBT
	"faggot", "faggit", "tranny", "trannie", "shemale", "lgbtqfag",
	-- sexual abuse
	"rapist", "pedophile", "pedofile", "paedophile", "paedofile",
	"paedo", "childmolester", "kidmolester", "kidfucker", "childrape",
	-- ableist
	"retarded", "mongoloid",
}

--- Terms that only match as a whole word — too short or too
--- collision-prone to be safe as substrings (see header).
ProfanityLibData.EXACT_TERMS = {
	["fag"] = true, ["fags"] = true, ["fagot"] = true, ["fagots"] = true,
	["nigg"] = true, ["nig"] = true,
	["negro"] = true, ["negros"] = true,
	["coon"] = true,
	["chink"] = true, ["chinks"] = true,
	["gook"] = true, ["gooks"] = true,
	["kike"] = true, ["kikes"] = true,
	["dyke"] = true, ["dykes"] = true,
	["nazi"] = true, ["nazis"] = true,
	["injun"] = true, ["injuns"] = true,
	["squaw"] = true, ["squaws"] = true,
	["beaner"] = true, ["beaners"] = true,
	["wigger"] = true, ["wiggers"] = true,
	["raghead"] = true, ["ragheads"] = true,
	["abbo"] = true, ["abbos"] = true,
	["boong"] = true, ["boongs"] = true,
	["heeb"] = true, ["heebs"] = true,
	["sheeny"] = true,
	["yid"] = true, ["yids"] = true,
	["kaffir"] = true, ["kaffirs"] = true,
	["gyppo"] = true,
	["darkie"] = true, ["darkies"] = true, ["darkey"] = true,
	["wog"] = true, ["wogs"] = true,
	["paki"] = true, ["pakis"] = true,
	["zyklon"] = true,
	["spastic"] = true,
}

--- Benign words removed from the folded string before the substring
--- scan. Corpus: Badtherapist, Terapist, Thurapist, guild "Therapists".
ProfanityLibData.EXCEPTIONS = {
	"therapist", "terapist", "thurapist",
}

--#endregion
