# Gameplay Tournament — 小小夢魔：理財迷航

Status: gameplay direction D and visual direction B are selected by the user. The approved style is Paper-cut Storybook: sage green, paper khaki, brick orange, layered cardstock forms, and clearly legible interaction objects. Player/teacher evidence and final acceptance remain pending.

## Locked profile and evidence plan

The user selected Learning first and Appropriate challenge/ease-of-entry second. The Learning-first preset is used: `wL=0.50, wE=0.15, wM=0.10, wA=0.25`. User-selected penalty strengths are operationalized as `pG=0.25` (strong guessing/exploitation penalty) and `pC=0.15` (moderate overload penalty). No G/C hard gate is selected; use review flags instead. `R_edu` thresholds are 75+ promising for a prototype, 60–74.99 revise/test, below 60 hold.

Observable evidence plan: L = short pre/post concept questions and explanation quality; E = voluntary completion/replay and persistence (not time alone); M = brief child-friendly confidence/retry item; A = error recovery, hint use, and facilitator-reported confusion; G = rapid random choice, repeated blind retry, or answer memorization; C = rereading, misunderstanding, and overload reports. No child evidence exists yet. All values below are **AI pre-score** hypotheses, low confidence, not measured results.

## Hard gates

Every candidate must meet the confirmed brief: exactly two levels; one interaction per level; key gated by correct response; per-level score; final progress summary; age-appropriate financial content; no real financial transactions; original IP. All six candidates pass these gates. There are no hard-gate eliminations.

## Candidate population (neutral IDs)

| ID | Name and fantasy | 30–60 second core loop | Trade-off / failure recovery | Minimum prototype |
|---|---|---|---|---|
| A | **暗廊補給站** — explore a shadowed ship and help a keeper divide stars between a future need and today's wants. | Walk to a supply table → choose a saving/spending plan → see the remaining supply → earn the key. | Save too little and receive a hint/retry; a retry still allows progress with a reduced score. | Two-room scene with one allocation decision per room. |
| B | **燈塔目標階梯** — guide a keeper toward a chosen lantern by setting aside small amounts over time. | Inspect a goal → choose how many stars to save → see the goal bar move → unlock a key. | More saving advances the goal but leaves less for immediate wants; retries expose the arithmetic. | Goal meter plus deterministic save/spend choices. |
| C | **霧港商人鑑識** — inspect a suspicious merchant's offer and identify a misleading promise. | Explore one clue-rich stall → select the warning sign → explain the choice → earn the key. | A wrong choice prompts a clue and another attempt; clue count risks extra reading. | One fixed offer and 2–3 readable clues per level. |
| D | **貨艙星箱配置** — place stars into a safe reserve and several investment cargo boxes before weather reaches the harbor. | Drag a small set of tokens into labeled boxes → reveal a deterministic scenario card → explain how the spread changes risk → earn the key. | Concentrating all tokens creates a more exposed outcome; a guided retry teaches diversification without random rewards. | Two identical cargo boards with distinct saving and investment objectives. |
| E | **夜霧路線抉擇** — choose a route through a dreamlike harbor, balancing a quick purchase against a future goal. | Inspect two routes → select a spending/saving consequence → receive feedback → earn the key. | Both routes have a cost; a calm retry offers a plain-language hint. | Two short branching vignettes, no timer. |
| F | **星潮市場模擬** — place stars in assets and watch a market event card change their value. | Choose an investment mix → reveal a market card → compare outcomes → earn the key. | Outcomes emphasize fluctuation but random rewards may encourage guessing or gambling associations. | Deterministic scenario deck with no real assets or currency. |

## Three evolution passes

1. **Generation 1 — distinct verbs:** allocate, save toward a goal, detect a claim, distribute tokens, choose a route, and simulate a market.
2. **Generation 2 — targeted mutations:** simplify B to one visible goal bar; constrain C to at most three short clues; remove time pressure from E; replace F's random payout with fixed scenarios; make D's weather cards deterministic; add explicit retry feedback to A.
3. **Generation 3 — convergence review:** preserve the materially different player verbs. D, A, and E remain the strongest distinct tests; no further cosmetic reskin is counted as a new concept. C and F are retained in the record as dominated alternatives, not silently discarded.

## Blind review lenses

- **Game designer pass:** D offers the clearest tactile choice; A has the simplest exploration-to-decision loop; E gives narrative agency but less replay depth.
- **First-time player pass:** B and A are easiest to explain; D needs clear target zones and a small number of tokens; C/F risk jargon or extra reading.
- **Domain pass:** CFPB guidance supports specific savings goals and small steps, and distinguishes saving for future spending from investing to grow wealth. Keep all investment outcomes hypothetical and avoid any guaranteed-return language. [CFPB saving guidance](https://www.consumerfinance.gov/consumer-tools/money-as-you-grow/school-age-children-preteens/explore-saving/) · [CFPB elementary curriculum review](https://files.consumerfinance.gov/f/documents/cfpb_youth-financial-education-curriculum-review-tool.pdf)
- **Research reviewer pass:** no player data; keep concept scores as AI pre-scores. D's deterministic event card offers reproducible decisions; F's random payoff is a confound and guessing incentive.
- **Production director pass:** A/B/E are low-cost in the existing 2D Godot setup; D adds drag/drop and board feedback at moderate cost; C requires localization/reading QA; F needs a simulation UI and more balancing.

## Final G / Purpose Fit / D scorecard

The project is a teaching product, not a formal research study, so the rubric's R axis is shown as **Purpose Fit (P)**. Scores are independent axes, not a hidden weighted total. Evidence: **AI pre-score**, low confidence.

| Pareto front / rank | ID | Game Experience G | Purpose Fit P | Feasibility D | L | E | M | A | G-guess | C-load | `R_edu` | Main risk / prototype cost |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 / 1 | D | 88 | 86 | 80 | 90 | 84 | 78 | 84 | 18 | 25 | **78.15** | Drag/drop clarity; medium cost. |
| 1 / 2 | A | 80 | 83 | 84 | 84 | 78 | 72 | 82 | 18 | 20 | **73.90** | Can feel like a quiz unless consequences are visible; low–medium cost. |
| 1 / 3 | E | 81 | 80 | 81 | 81 | 76 | 75 | 73 | 24 | 24 | **68.05** | Route choices may feel arbitrary; low–medium cost. |
| 1 / 4 | B | 75 | 88 | 92 | 90 | 65 | 68 | 78 | 15 | 20 | **74.30** | Low agency/replay unless saving choices have clear consequences; low cost. |
| 2 | C | 82 | 78 | 75 | 76 | 87 | 80 | 68 | 35 | 28 | **63.10** | Reading load and clue-guessing; medium cost. |
| 2 | F | 84 | 72 | 77 | 86 | 82 | 69 | 65 | 40 | 45 | **61.70** | Randomness encourages guessing and overload; medium–high cost. |

Calculation example for D: `0.50*90 + 0.15*84 + 0.10*78 + 0.25*84 - 0.25*18 - 0.15*25 = 78.15`. Values and thresholds are design diagnostics only, not research constants or learner outcome claims.

Pareto fronts were calculated over G/P/D. Front 1 contains A, B, D, E. Per the locked tie-breakers, compare lowest axis first, then mean: D (80; 84.67), A (80; 82.33), E (80; 80.67), B (75; 85.00). The ranked shortlist is D, A, E; B is a close fourth. D dominates C and F on all three axes, so they are front 2. `R_edu` remains separate from these axes.

## Recommended next falsifiable tests

- D: in a 5-minute paper/greybox prototype, can a child explain why splitting tokens changes exposure without being told the answer?
- A: after one retry, can a child distinguish a planned reserve from unplanned spending?
- E: can a child predict and explain the future consequence of each route choice?

Use age-appropriate tasks and guardian/institution consent before child playtesting. No participant data should be collected until approval and a method are defined.

## Gameplay decision outcome

The user selected **D — 貨艙星箱配置**. Alternatives A and E remain viable but were not selected; B is the close fourth-place option; C and F are dominated by D on G/P/D. This decision is recorded in `decision-log.md`.

The playable build implements D using three-box saving and investment allocation. Visual direction B is approved; the Godot scene is being updated to the selected paper-cut storybook style. Player/teacher evidence and final acceptance remain open.
