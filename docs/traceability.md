# Requirements Traceability

| Need | Requirement | Design / implementation | Test evidence | User acceptance | Status |
|---|---|---|---|---|---|
| N-001 Financial learning for elementary children | FR-001 Saving/spending and investment/risk objectives use age-appropriate examples. | `game.gd`, lesson scenarios; source grounding in `project-brief.md`. | T-001 content review pending after gameplay approval. | Pending playtest/teacher review. | Draft |
| N-002 Two levels, one interaction each | FR-002 Exactly two lesson interactions, implemented as cargo allocation in approved concept D. | `game.gd`, three-box allocation interface on each level. | T-002 manual full-flow test passed in Godot window. | Pending teacher/player review. | Implemented in initial build |
| N-003 Correct answer unlocks each key | FR-003 Wrong allocation keeps key locked; a successful allocation and explanation awards it. | `game.gd`, stage-specific total and distribution validation. | T-002 tested valid and invalid allocation; keys and progression observed. | Pending teacher/player review. | Implemented in initial build |
| N-004 Per-level scores | FR-004 Show each level's score and total. | `game.gd`, `scores[]`, `refresh_hud()`. | T-002 both successful scores and wrong-submission deduction observed. | Pending. | Implemented in initial build |
| N-005 Final learning progress | FR-005 Show both scores and completed learning units. | `game.gd`, `show_ending()`. | T-002 ending showed 2/2 units, each level and total score; restart tested. | Pending. | Implemented in initial build |
| N-006 Original Blender props | FR-006 Provide editable BLEND and Godot-compatible GLB. | `blender/make_props.py`; `blender/little_dream_props.blend`; `assets/little_dream_props.glb`; runtime GLTF load in `game.gd`. | Blender generated BLEND/GLB; model preview visible in game. | Visual style approval pending. | Implemented in initial build |
| N-007 Deploy to requested GitHub repository | NFR-001 Repository contains Godot source, Blender generator, and original game asset. | Local Git files prepared; `.gitignore` excludes `.godot/`. | Remote read succeeded; no push/commit identity or GitHub write connection. | User requested deployment; skill design/release gates remain pending. | Blocked/pending |

## Test register

- T-001: Godot 4.7.2 headless startup of `main.tscn` — passed; game script reported no errors.
- T-002: manual two-level valid/invalid allocation, score, key, ending, and restart — passed in the Godot window; the final penalty was confirmed as 25 points for an invalid complete allocation.
- T-003: Blender 5.2.4 LTS generation and Godot GLB import — passed; visual appearance not manually inspected.
