# 小小夢魔：理財迷航 — Project Brief

Status: draft

## Goal

Create an original, child-friendly financial-literacy adventure that teaches elementary learners to plan spending and savings, then recognize investment risk and diversification.

## Target users and context

- Elementary-school children; provisional design band: approximately ages 7–11.
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

- Input: movement, one lesson decision per level, and optional retries.
- Processing: deterministic answer checking; award a key only after the correct answer; calculate level and total scores.
- Output: immediate explanatory feedback, two level scores, and a completion summary showing the two learning units completed.

## AI role and authority

No AI runs in the game. Game rules, scoring, answers, and progression are deterministic. Design scoring in this brief is an AI pre-score and does not replace learner evidence.

## MVP and non-goals

MVP: exactly two levels; one financial-literacy interaction per level; answer-gated keys; level scores; final progress summary; original atmospheric visuals; Blender-made 3D props.

Non-goals: real money, real investment recommendations, online accounts, student data collection, multiplayer, horror violence, or copying Little Nightmares characters or locations.

## Constraints and risks

- Keep reading load and controls suitable for children.
- Do not frame an investment as guaranteed or risk-free.
- Do not use timers or randomized payouts that reward guessing unless approved by the design gate.
- No identifiable child data; obtain required guardian/institutional approval before any playtest.
- Godot 4.7.2 and Blender 5.2.4 LTS are installed; game concept and visual direction remain unapproved.

## Delivery context

Windows desktop Godot project. GitHub repository target: `https://github.com/kellyku1025-stack/game2`; publication is pending design gates and write authentication.

## Success measures

- A first-time learner can move and find the interaction without adult explanation.
- Each level has exactly one lesson interaction and awards its key only after a correct answer.
- Per-level scores and the final progress summary are visible and consistent.
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

- Human gameplay-candidate selection and subsequent visual-direction selection.
- Exact age band and classroom time allocation.
- GitHub connection and commit author identity.

## User approval

Original two-level brief is confirmed by the user's direct request. The evolved gameplay and visual design are not yet approved.
