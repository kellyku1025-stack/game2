# 星港理財局：零用錢任務 — Project Brief

Status: approved requirement change; revised prototype pending verification

## Goal

Create an original financial-literacy adventure for junior-high learners that practices budgeting, purchase decisions, saving, and handling an unexpected expense.

## Target users and context

- Junior-high students; provisional design band: approximately ages 12–15.
- Windows desktop, single-player, short sessions.
- Traditional Chinese UI; classroom or home learning context.

## Evidence and pain points

- The user's brief requires two levels, one interaction in each, a key earned only after a correct answer, per-level scores, and a final progress summary.
- CFPB's school-age guidance recommends age-appropriate conversations and concrete savings goals broken into small steps. [CFPB: School-age children and saving](https://www.consumerfinance.gov/consumer-tools/money-as-you-grow/school-age-children-preteens/explore-saving/)
- CFPB's elementary curriculum review separates saving for future spending from investing to increase wealth over time, and includes elementary-level spending plans and financial-risk concepts. [CFPB: Youth curriculum review tool](https://files.consumerfinance.gov/f/documents/cfpb_youth-financial-education-curriculum-review-tool.pdf)
- OECD reports an association between financial literacy and positive behaviors such as saving and comparing prices; this is domain context, not evidence that this game is effective. [OECD: Student financial literacy](https://www.oecd.org/en/topics/student-financial-literacy.html)
- The user supplied Little Nightmares as a mood reference. The project uses only a dark, atmospheric exploration/puzzle direction and must keep characters, setting, story, and assets original. [Steam reference](https://store.steampowered.com/app/424840/Little_Nightmares/?l=tchinese)

## Problem statement

Elementary learners need a low-pressure way to practice distinguishing planned saving from immediate spending and to reason about investment risk without presenting real financial products or promising returns.

## Inputs, processing, and outputs

- Input: movement, budget percentages, need/want classifications, six spending decisions, and one unexpected-expense decision.
- Processing: deterministic answer checking; award each unit's key only when its task is complete; deduct 10 points for each incorrect choice; incomplete budget totals are correctable without penalty.
- Output: immediate explanation after each shopping and traffic-light choice, four unit scores, a total out of 400, and a final progress summary.

## AI role and authority

No AI runs in the game. Game rules, scoring, answers, and progression are deterministic. Design scoring in this brief is an AI pre-score and does not replace learner evidence.

## MVP and non-goals

MVP: four sequential interactions: (1) allocate a budget among needs, wants, savings, and investment; (2) classify items at a breakfast shop, convenience store, and traditional grocery; (3) make six traffic-light spending decisions; (4) respond to an unexpected expense. Each unit has a score and answer-gated key; the ending shows progress across all four units. Use an original, bright isometric starport island with colorful shops, gardens, a lagoon, playful helpers, and high-contrast rounded HUD panels; do not copy logos, characters, or scene layouts from the visual references. Retain original Blender-made 3D props.

Non-goals: real money, real investment recommendations, online accounts, student data collection, multiplayer, horror violence, or copying Little Nightmares characters or locations.

## Constraints and risks

- Keep reading load and controls suitable for junior-high students.
- Do not frame an investment as guaranteed or risk-free.
- Do not use timers or randomized payouts that reward guessing unless approved by the design gate.
- No identifiable child data; obtain required guardian/institutional approval before any playtest.
- Godot 4.7.2 and Blender 5.2.4 are installed; gameplay direction D and visual direction B (Paper-cut Storybook) are selected. The playable build is published on GitHub Pages with a versioned path for each deployment.

## Delivery context

Windows desktop Godot project with a browser build published through GitHub Pages Actions at `https://kellyku1025-stack.github.io/game2/`.

## Success measures

- A first-time learner can move and find each interaction without adult explanation.
- The four activities appear in the requested sequence and explain shopping classifications after each checkout.
- The six traffic-light situations offer the three requested options.
- Each completed unit awards its key; scores and the final 4/4 progress summary are visible and consistent.
- Learners can explain, in their own words, why the selected saving/spending or risk choice is appropriate.
- Any future learning claim is supported by an approved pre/post measure, not an AI score.

## Assumptions to test

- A dark storybook environment can create curiosity without frightening the target age.
- Short narrative scenarios and one decision per level keep cognitive load manageable.
- The selected controls, text size, and 3D prop inset remain readable on common desktop displays.

## Acceptance examples

1. If a learner selects an incorrect response, the key remains locked and a short teaching hint appears.
2. If a learner selects the correct response, the key is awarded and the level score updates.
3. After level two, the completion screen shows both level scores and completed learning units.
4. Restarting resets scores, attempts, keys, and progress.

## Open questions

- Grade-specific teacher review, classroom time allocation, and whether the proposed budget percentages need adjustment for local curriculum.
- Child/teacher usability evidence and final acceptance.

## User approval

Original two-level brief is confirmed by the user's direct request. Gameplay direction D and visual direction B were explicitly selected by the user. The user also requested GitHub Pages deployment.
