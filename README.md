# Is It He or She?

Interactive dashboard for *Contrasting Gender Bias in Machine Translation and Generative AI* —
a two-wave study of how four translation systems assign English gender to Indonesian
occupational propositions that carry none.

Indonesian marks no gender on its third-person pronoun *dia*, so every English rendering
forces a choice the source never made. Each of the 128 occupations was submitted as a matched
pair of clauses — one praising competence (*cekatan*), one describing carelessness (*ceroboh*) —
across Bing Translator, Google Translate, DeepL and ChatGPT, in **May 2023** and again in
**August 2026**.

## Coding scheme

| Code | Condition |
|---|---|
| Masculine | both clauses return *he* / *his* |
| Feminine | both clauses return *she* / *her* |
| Split-gender | the two clauses differ |

## Contents

| File | Description |
|---|---|
| `index.html` | Self-contained dashboard. No build step, no network calls — open it in any browser. |
| `Research Data.xlsx` | Source workbook: raw renderings, per-platform coding sheets, and an analytical overview whose figures are live formulas. |

## Viewing

Open `index.html` directly, or publish it with GitHub Pages
(*Settings → Pages → Deploy from branch → main → / (root)*).

## Data note

The occupation list derives from Kinanti, N. A., Syaebani, M. I., & Primadini, D. V. (2021).
*Stereotip pekerjaan berbasis gender dalam konteks Indonesia.* Jurnal Manajemen dan Usahawan
Indonesia, 44(1). https://doi.org/10.7454/jmui.v44i1.1025 — the masculine/feminine/neutral
labels applied here are the authors' own re-classification and differ from the distribution
published in that source.

Each wave is a single collection pass. Both Google Translate and ChatGPT were observed
returning different renderings for identical inputs, so the figures describe those passes
rather than fixed properties of the systems.
