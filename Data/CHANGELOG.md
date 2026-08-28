# ProfanityLibData Changelog

## V2 — 2026-08-28

- Support all game flavors. The TOC now lists Retail (120100), Mists Classic
  (50504), Anniversary/TBC (20506), and Classic Era (11509) interface numbers
  so the data package loads on every client.

## V1 — 2026-08-12

- Initial release.
- The wordlist for ProfanityLib, shipped as its own data package from the
  start: substring terms, whole-word-only terms, and an exception list for
  benign words that contain a term ("therapist").
- Validated against a corpus of 808,940 character names + 17,205 guild names
  from the death databases: 78 flagged, zero false positives.
