# Is It He or She?

**Contrasting gender bias in machine translation and generative AI — a 2023/2026 replication**

Indonesian marks no gender on its third-person pronoun *dia*. Translating it into English
therefore forces a choice the source never made, and whatever the system chooses is its own
contribution, not the author's. This repository holds the data and the interactive dashboard
for a two-wave study of how four systems make that choice.

Ardik Ardianto · Enggar Mulyajati
English Language and Literature Department, Universitas Terbuka, Indonesia

---

## Design

128 Indonesian occupations, each submitted as a **matched pair of clauses** — one praising
competence (*cekatan*), one describing carelessness (*ceroboh*):

> *Dia apoteker yang cekatan. Dia apoteker yang ceroboh.*
> "Dia is a skilled pharmacist. Dia is a careless pharmacist."

Pairing the clauses is what makes the design informative. A system can be consistent (both
clauses one gender) or it can assign the two clauses **different** genders — and if it does,
the direction of that split is itself a result.

| Code | Condition |
|---|---|
| **Masculine** | both clauses return *he* / *his* |
| **Feminine** | both clauses return *she* / *her* |
| **Split-gender** | the two clauses differ |

Platforms: Bing (Microsoft) Translator, Google Translate, DeepL, ChatGPT.
Waves: **26 May 2023** and **28 August 2026**. 128 occupations × 4 platforms × 2 waves =
1,024 coded assignments.

---

## Results

Share of the 128 occupations receiving each assignment.

| Platform | Wave | Masculine | Feminine | Split-gender |
|---|---|---:|---:|---:|
| Bing Translator | 2023 | 119 (93.0%) | 4 (3.1%) | 5 (3.9%) |
| | **2026** | **126 (98.4%)** | 2 (1.6%) | 0 |
| Google Translate | 2023 | 120 (93.8%) | 5 (3.9%) | 3 (2.3%) |
| | **2026** | 50 (39.1%) | 2 (1.6%) | **76 (59.4%)** |
| DeepL | 2023 | 107 (83.6%) | 16 (12.5%) | 5 (3.9%) |
| | **2026** | 117 (91.4%) | 11 (8.6%) | 0 |
| ChatGPT | 2023 | 115 (89.8%) | 13 (10.2%) | 0 |
| | **2026** | 75 (58.6%) | **53 (41.4%)** | 0 |

**The platforms diverged rather than converged.** In 2023 all four agreed that 103 of the 128
occupations were masculine; by 2026 that consensus had fallen to 39. No occupation is
rendered feminine by all four in 2026.

**Google Translate did not become neutral — it became asymmetric.** Of the 76 occupations it
now splits, **64 attach the competent clause to a man and the careless clause to a woman**.
Twelve run the other way.

**ChatGPT moved in the opposite direction, and overshot.** Feminine output quadrupled from 13
to 53 occupations. But it applies *she* to 65% of the occupations classified as neutral, so
the gain reflects a shifted default rather than sensitivity to the occupation.

**Stability varies by an order of magnitude.** Occupations whose assignment changed between
waves: Bing 7, DeepL 16, ChatGPT 42, Google Translate 77.

---

## Contents

| Path | Description |
|---|---|
| `index.html` | Self-contained dashboard — no build step, no network calls, no dependencies. Open in any browser. |
| `Research Data.xlsx` | Source workbook (see below). |

### Workbook structure

| Sheet | Contents |
|---|---|
| `Analytical Overview` | Nine sections of live formulas: distributions, between-wave change, transition matrix, split direction, classification lens, cross-platform agreement, and a dated audit trail of every correction applied. |
| `Overall` | One row per occupation, all four platforms and both waves. Columns AC–AD carry the classification and split-direction keys the analysis reads. |
| `Raw Data` | The 128 Indonesian source propositions. |
| `Bing Translator`, `Google Translate`, `DeepL`, `ChatGPT` | Verbatim renderings for both waves alongside their codings. |

Every figure in the Analytical Overview is a formula over the coding sheets. Nothing is typed
in by hand, so correcting a coding updates the analysis.

---

## Occupation classification

The occupations derive from the inventory of Kinanti, Syaebani and Primadini (2021), whose
survey of 3,633 Indonesian respondents classified occupations as masculine, feminine or
neutral.

The labels applied here — **10 feminine, 58 masculine, 60 neutral** — are the present authors'
own re-classification and differ from the 26 / 46 / 57 distribution published in that source.
They should be attributed to this study, not to Kinanti et al.

> Kinanti, N. A., Syaebani, M. I., & Primadini, D. V. (2021). Stereotip pekerjaan berbasis
> gender dalam konteks Indonesia. *Jurnal Manajemen dan Usahawan Indonesia, 44*(1).
> https://doi.org/10.7454/jmui.v44i1.1025

---

## Limitations

- **Single-pass collection.** Each wave is one submission per proposition. During verification
  both Google Translate and ChatGPT returned different renderings for identical inputs, so
  these figures describe those passes, not fixed properties of the systems.
- **Interface, not API.** Renderings were collected through each platform's public web
  interface on the stated dates. Results may differ from the corresponding APIs.
- **Three incomplete returns.** Google Translate 2026 returned a single clause rather than the
  pair for *Manajer Motel*, *Penjual Mesin Bisnis* and *Penjual Obat-Obatan*. These are coded
  masculine on the researchers' judgement, since the two-clause rule cannot strictly apply.
- **Not a benchmark.** 128 occupations in one language pair. The design detects direction and
  asymmetry, not effect sizes generalisable to other pairs.

---

## Viewing

Open `index.html` directly, or publish it with GitHub Pages:
*Settings → Pages → Deploy from branch → `main` → `/ (root)`*.

## Citation

> Ardianto, A., & Mulyajati, E. (2026). *Is it he or she? Contrasting gender bias in machine
> translation and generative AI* [Data set and dashboard]. https://github.com/ardikardianto/contrasting-gender-bias
