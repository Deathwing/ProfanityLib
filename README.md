# ProfanityLib

**ProfanityLib** is a lightweight profanity matching library for World of Warcraft addons.

It checks user-supplied strings — character names, guild names, last words — against a curated slur wordlist, so addons that display data from other players can filter out offensive content before showing it.

### What This Library Provides

* `ProfanityLib:IsProfane(text)` — returns whether a string matches, plus the matched term
* `ProfanityLib:Clean(text)` — the inverse, for readable call sites
* `ProfanityLib:AddTerm(term, exact)` — extend the wordlist at runtime
* Accent folding (`ï→i`, `ñ→n`, `ø→o`, `æ→ae`, `ß→ss`, …) and leetspeak folding (`0→o`, `1→i`, `3→e`, `4→a`, `5→s`, `7→t`, `$→s`, `@→a`, `!→i`) so obfuscated spellings such as `Nïggér` or `N1gger` still match
* Substring terms plus whole-word-only terms for short, collision-prone words, plus an exception list for benign words that contain a term ("therapist")

### Design

The wordlist ships as its own data package (**ProfanityLibData**) and covers racial, antisemitic, anti-LGBT, and ableist slurs plus Nazi and sexual-abuse references. Every term was validated against a corpus of 824,414 real character names and 17,463 guild names extracted from Deathlog's death databases: the list flags 104 of 841,877 corpus strings, all deliberate. Candidate terms that collided with legitimate names (`heeb` → Pheebe, `yid` → Sayid, `chink` → Schinkenpelz…) were demoted to whole-word-only matching or dropped; the reasoning for each is documented in the data package. Matching a legitimate player name is treated as worse than missing an obfuscated slur.

### Who Should Install This

* You normally do not install this directly — addons that use it either embed it or list it as a dependency.
* No UI, no slash commands, no standalone player-facing functionality.

### Used By

- [Deathlog](https://www.curseforge.com/wow/addons/deathlog) — filters offensive character names, guild names, and last words

### Links

- [Source Code (GitHub)](https://github.com/Deathwing/ProfanityLib)
