# ProfanityLib Changelog

## V2 — 2026-08-28

- Support all game flavors. The TOC now lists Retail (120100), Mists Classic
  (50504), Anniversary/TBC (20506), and Classic Era (11509) interface numbers
  so the library loads on every client.

## V1 — 2026-08-12

- Initial release.
- `ProfanityLib:IsProfane(s)` / `:Clean(s)` / `:AddTerm(term, exact)`.
- Leetspeak folding (`0→o`, `1→i`, `3→e`, `4→a`, `5→s`, `7→t`, `$→s`, `@→a`, `!→i`).
- The wordlist ships in its own data package (ProfanityLibData): substring
  terms, whole-word-only terms, and an exception list for benign words that
  contain a term ("therapist").
- Validated against a corpus of 808,940 character names + 17,205 guild names
  from the death databases: 78 flagged, zero false positives.
