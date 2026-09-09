--[[
ProfanityLibData~Tables.lua

The wordlist. Terms are stored pre-folded (lowercase ASCII letters only —
see fold() in ProfanityLib~Match): matching folds the input the same way,
so a term containing a digit or symbol would never match.

Every term was validated against a corpus of 824,414 real character names
and 17,463 guild names extracted from the death databases (2026-09-09);
104 of 841,877 strings are flagged and all are deliberate, the one
debatable hit being the guild "Le Coon et sa bande" (a South Park
reference caught by the exact term "coon"). Candidate terms that collided
with legitimate names were demoted to EXACT_TERMS or dropped:

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
  kyke   -> Cheekykent, Kinkykelly, Skyket      (5 hits, exact only)
  himmler -> Schimmler, Schimmlerr              (dropped)
  niger  -> Snigeren, Reinigerr, Thenigerian   (15 hits, dropped)
  dago   -> Dagobert, Canadagoose, Dagobah      (105 hits, dropped)
  polack / mengele -> Polacko, Mengelele        (dropped, ambiguous)
  jap / kraut / spook / zog / heil -> everyday words or syllables in
            other languages (140-371 hits each, dropped)

Since ProfanityLib V3 accented Latin letters fold to ASCII before
matching, so every term above also covers spellings such as "Nïggér",
"Fàggot" or "Trännyfäggot" (26 corpus strings that V2 missed). Two
accidental V2 catches are gone: "Negrão" and "Niggé" used to fold to the
exact words "negro" / "nigg" once their accented letter was stripped. Both
are also real surnames, and "nigge" as a substring would hit Bonigge,
Niggels and Säuniggel, so they are not re-added.

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
	"nigger", "niggr", "nigga", "nigguh", "niglet", "nigglet", "nignog",
	"negrosucks", "jigabo", "jiggabo", "junglebunny", "porchmonkey",
	"spearchucker", "tarbaby", "pickaninny", "picaninny", "sheboon",
	"golliwog", "groid", "coalburner", "dindunuffin", "dindunothin",
	"shitskin",
	-- anti-Asian
	"chingchong", "chinaman", "slanteye", "zipperhead",
	-- anti-Latino
	"wetback",
	-- anti-Arab / anti-Muslim
	"towelhead", "cameljockey", "goatfucker", "mudslime",
	-- anti-Indian
	"currymuncher", "pajeet",
	-- antisemitic / Nazi
	"gasjew", "ovenjew", "jewburner", "jewboy", "heilhitler", "hitler",
	"holocaust", "gaschamber", "auschwitz", "zyklonb", "swastika",
	"siegheil", "whitepower", "kukluxklan",
	-- anti-LGBT
	"faggot", "faggit", "fagget", "tranny", "trannie", "shemale", "lgbtqfag",
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
	["kike"] = true, ["kikes"] = true, ["kyke"] = true, ["kykes"] = true,
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
	["zyklon"] = true, ["kkk"] = true,
	["spastic"] = true,
}

--- Benign words removed from the folded string before the substring
--- scan. Corpus: Badtherapist, Terapist, Thurapist, guild "Therapists".
ProfanityLibData.EXCEPTIONS = {
	"therapist", "terapist", "thurapist",
}

--#endregion
