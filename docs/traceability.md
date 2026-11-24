# Requirements Traceability

| Need | Requirement | Design / implementation | Test evidence | User acceptance | Status |
|---|---|---|---|---|---|
| N-001 Financial learning for junior-high students | FR-001 Use familiar spending, saving, budget, and emergency-expense examples; explain investment risk without promising returns. | `game.gd`, four activity datasets and feedback. | Content review and gameplay verification pending. | Pending teacher/student review. | Revised |
| N-002 Budget planning | FR-002 Allocate 100% across needs, wants, savings, and investment; accept multiple allocations within the displayed ranges. | `game.gd`, four percentage sliders and deterministic range checks. | Pending manual test. | Pending. | Implemented locally |
| N-003 Need/want shopping | FR-003 Visit breakfast shop, convenience store, and traditional grocery in order; classify each of nine products and show its rationale after checkout. | `SHOP_ITEMS`, per-item feedback and sequential store labels in `game.gd`. | Pending manual test of all three stores and explanations. | Pending. | Implemented locally |
| N-004 Spending decision practice | FR-004 Present six scenarios with choices “立刻買／想一想／先存錢” and explain the decision cue after each. | `TRAFFIC_QUESTIONS` and sequential choice flow in `game.gd`. | Pending manual test verifying all six items and choices. | Pending. | Implemented locally |
| N-005 Unexpected expense | FR-005 Present a surprise expense and let the learner choose a response involving an emergency reserve, existing plans, and help from a trusted adult. | `EMERGENCY_SITUATION`, deterministic choices and feedback in `game.gd`. | Pending manual test for correct and incorrect responses. | Pending teacher review. | Implemented locally |
| N-006 Keys, scores, and progress | FR-006 Each completed unit awards its key; show unit scores, total /400, and final 4/4 learning progress. | `solved[]`, `scores[]`, `refresh_hud()`, `_finish_stage()`, `show_ending()`. | Pending manual full-flow, score, key, and restart test. | Pending. | Implemented locally |
| N-007 Original Blender props | FR-007 Retain editable BLEND and Godot-compatible GLB. | `blender/make_props.py`, `blender/little_dream_props.blend`, `assets/little_dream_props.glb`. | Initial build generation/runtime preview passed; regression check after update pending. | Pending. | Existing asset retained |
| N-008 GitHub Pages release | NFR-001 Publish the revised Godot Web build to the existing Pages site after verification. | Repository workflow `.github/workflows/deploy-pages.yml`. | Previous two-unit deployment passed; revised build not yet exported or deployed. | Pending revised release. | Pending |

## Test register

- T-001 (baseline): Godot 4.7.2 headless startup passed for the previous two-unit build.
- T-002 (baseline): previous two-unit allocation, scoring, keys, ending, and restart were manually tested. This evidence does not cover the revised four-unit flow.
- T-003 (baseline): Blender-generated BLEND/GLB loaded in Godot in the previous build.
- T-004 (baseline): previous Godot Web export and GitHub Pages deployment passed; the revised build still needs a new deployment check.
- T-005 (pending): manually complete budget allocation with valid and invalid percentages; verify feedback, score, key, and total.
- T-006 (pending): classify all nine items across the three stores and verify item-by-item explanations.
- T-007 (pending): complete all six traffic-light situations and verify each offers the three required actions.
- T-008 (pending): test correct and incorrect emergency decisions, then complete all four units and inspect the /400 summary and restart.
- T-009 (pending): inspect Chinese rendering, layout, Blender preview, and browser build after revision.
