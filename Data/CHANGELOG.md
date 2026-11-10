# ProfanityLibData Changelog

## V4 — 2026-11-10

- When more than one copy is installed, the newest installed copy is used. A copy from V3 or earlier cannot be taken over and stays in use until it is updated.
- Support World of Warcraft: Forever and Patch 12.1.5. The TOC now also lists the interface numbers 16001 and 120105.

## V3 — 2026-09-09

- **Re-checked for ProfanityLib V3**, which now ignores accents when
  matching. The existing wordlist catches 26 accented spellings from the
  real-name corpus that were previously missed (`Nígger`, `Trännyfäggot`,
  `Hitlér`, `Ñigga`, …) without flagging any legitimate name, so no new
  exceptions were needed.
- **New terms:** `jewboy`, `chinaman`, `fagget` and `niggr`, all with zero
  innocent matches in the corpus; `kyke` and `kkk` as whole words only.
- **Checked and left out:** `himmler` (Schimmler), `niger` (Snigeren,
  Reiniger, Thenigerian), `dago` (Dagobert, Canadagoose), `polack`,
  `mengele`, and everyday words in other languages such as `jap`, `kraut`,
  `spook`, `zog` and `heil`. The reasoning is kept in the wordlist header.
- **Corpus refreshed:** 824,414 character names and 17,463 guild names from
  the current death databases, 104 flagged. Two names that were only caught
  by accident before (`Negrão`, `Niggé`, both also real surnames) are no
  longer flagged.

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
