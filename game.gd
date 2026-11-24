extends Node2D

const TOTALS := [10, 12]
const BOX_NAMES := [
	["儲蓄箱", "生活需要", "想要的東西"],
	["星港商店", "月光農場", "雲端工坊"]
]
const LESSON_TITLES := ["第一關｜先存再花", "第二關｜分散投資"]
const LESSON_PROMPTS := [
	"把 10 枚星幣裝進三個貨箱。先照顧生活需要、留下一些儲蓄，再安排想要的東西。",
	"把 12 枚星幣分到三家不同商店。每家最多放 6 枚，分散配置可以降低單一商店出問題的影響。"
]
const LESSON_RULES := [
	"通關條件：總數剛好 10 枚；生活需要至少 5 枚、儲蓄至少 3 枚、想要的東西不超過 2 枚。",
	"通關條件：總數剛好 12 枚；至少分給 2 家商店，而且每家不超過 6 枚。"
]
const WRONG_HINTS := [
	"先檢查總數，再確保需要與儲蓄有足夠星幣，最後才安排想要的東西。",
	"試著把星幣分到至少兩家商店；每一家都不要超過 6 枚。"
]

var stage := 0
var player_x := 130.0
var active := false
var finished := false
var solved := [false, false]
var scores := [0, 0]
var mistakes := [0, 0]
var allocations := [[0, 0, 0], [0, 0, 0]]
var notice := "用 A / D 或方向鍵走到發光貨桌旁，按 E 開始配置。"
var notice_time := 10.0

var hud: VBoxContainer
var overlay: ColorRect
var panel: PanelContainer
var lesson_box: VBoxContainer
var allocation_labels: Array[Label] = []
var total_label: Label
var feedback_label: Label
var submit_button: Button
var notice_label: Label
var travel_button: Button
var prop_view: SubViewport

func _ready() -> void:
	set_process_input(true)
	_build_ui()
	refresh_hud()
	queue_redraw()

func _process(delta: float) -> void:
	if notice_time > 0.0:
		notice_time -= delta
		if is_instance_valid(notice_label):
			notice_label.text = notice if notice_time > 0.0 else ""
	if active or finished:
		return
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_key_pressed(KEY_A): direction -= 1.0
	if Input.is_key_pressed(KEY_D): direction += 1.0
	player_x = clampf(player_x + direction * 245.0 * delta, 45.0, 1235.0)
	if Input.is_key_pressed(KEY_E) and absf(player_x - 900.0) < 210.0:
		open_interaction()
	if player_x > 1210.0 and solved[stage]:
		_travel_forward()
	queue_redraw()

func _input(event: InputEvent) -> void:
	if active or finished or not (event is InputEventMouseButton):
		return
	var click := event as InputEventMouseButton
	if click.button_index != MOUSE_BUTTON_LEFT or not click.pressed or click.position.y < 130.0:
		return
	# Click-to-walk makes the short prototype easier to try with a mouse.
	player_x = clampf(click.position.x, 45.0, 1235.0)
	if absf(player_x - 900.0) < 210.0 and not solved[stage]:
		player_x = 900.0
		open_interaction()
	queue_redraw()

func _draw() -> void:
	var wall := Color("dbe6d8") if stage == 0 else Color("d9e1d3")
	var paper_shadow := Color("786f5d", 0.22)
	draw_rect(Rect2(0, 0, 1280, 720), Color("e8dfc9"))
	# Layered cut-paper wall panels and folded beams.
	draw_colored_polygon(PackedVector2Array([Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 126), Vector2(0, 164)]), paper_shadow)
	draw_colored_polygon(PackedVector2Array([Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 112), Vector2(0, 148)]), wall)
	draw_line(Vector2(0, 148), Vector2(1280, 112), Color("91a78d"), 5)
	for i in range(7):
		var x := float(i * 192 - 15)
		var panel_points := PackedVector2Array([Vector2(x, 158), Vector2(x + 164, 149), Vector2(x + 164, 414), Vector2(x, 424)])
		_draw_paper_layer(panel_points, Color("887c65", 0.16), [Color("b8c9b2"), Color("e6d8bb"), Color("d9c7a4")][i % 3], 7.0)
		for y in range(180, 402, 58):
			draw_line(Vector2(x + 18, y), Vector2(x + 145, y - 5), Color("788f7d", 0.30), 3)
	# A cream floor with paper tile seams.
	draw_colored_polygon(PackedVector2Array([Vector2(0, 450), Vector2(1280, 424), Vector2(1280, 720), Vector2(0, 720)]), Color("c5b99e"))
	for y in range(480, 720, 52):
		draw_line(Vector2(0, y), Vector2(1280, y - 26), Color("f0e5cd", 0.8), 3)
	for x in range(0, 1280, 112):
		draw_line(Vector2(x, 445), Vector2(x - 22, 720), Color("f0e5cd", 0.72), 3)
	# The arch opens after the key is earned.
	var door := PackedVector2Array([Vector2(1162, 438), Vector2(1162, 265), Vector2(1179, 226), Vector2(1211, 211), Vector2(1245, 226), Vector2(1260, 265), Vector2(1260, 438)])
	_draw_paper_layer(door, paper_shadow, Color("a66a42") if solved[stage] else Color("728775"), 8.0)
	draw_colored_polygon(PackedVector2Array([Vector2(1176, 429), Vector2(1176, 266), Vector2(1188, 238), Vector2(1211, 226), Vector2(1234, 238), Vector2(1246, 266), Vector2(1246, 429)]), Color("e8dfc9"))
	if solved[stage]: draw_line(Vector2(1178, 425), Vector2(1178, 264), Color("d38b54"), 7)
	# Paper workbench and parcels make the interaction easy to spot.
	draw_circle(Vector2(900, 300), 145, Color("f3c96e", 0.17))
	draw_rect(Rect2(773, 237, 24, 209), Color("9c714e"))
	draw_rect(Rect2(1012, 237, 24, 209), Color("9c714e"))
	draw_rect(Rect2(758, 343, 300, 23), Color("b8794c"))
	draw_line(Vector2(760, 343), Vector2(1056, 343), Color("e2ad71"), 5)
	draw_rect(Rect2(770, 424, 276, 18), Color("a66a42"))
	for i in range(3):
		var bx := 798.0 + i * 72
		var parcel := PackedVector2Array([Vector2(bx, 335), Vector2(bx + 4, 304), Vector2(bx + 48, 304), Vector2(bx + 53, 335)])
		_draw_paper_layer(parcel, paper_shadow, [Color("718f78"), Color("c38a55"), Color("8b7f9e")][i], 4.0)
		draw_line(Vector2(bx + 8, 311), Vector2(bx + 46, 311), Color("f2dfbd"), 3)
	# Original little traveler in a warm paper cloak.
	draw_line(Vector2(player_x - 10, 430), Vector2(player_x - 15, 455), Color("695747"), 5)
	draw_line(Vector2(player_x + 10, 430), Vector2(player_x + 15, 455), Color("695747"), 5)
	draw_circle(Vector2(player_x, 371), 14, Color("d5a46f"))
	_draw_paper_layer(PackedVector2Array([Vector2(player_x - 17, 383), Vector2(player_x + 17, 383), Vector2(player_x + 26, 434), Vector2(player_x - 25, 434)]), paper_shadow, Color("c47b45"), 5.0)
	draw_colored_polygon(PackedVector2Array([Vector2(player_x - 11, 392), Vector2(player_x + 11, 392), Vector2(player_x + 16, 430), Vector2(player_x - 16, 430)]), Color("e3a95d"))

func _draw_paper_layer(points: PackedVector2Array, shadow: Color, paper: Color, offset: float) -> void:
	var shifted := PackedVector2Array()
	for point in points:
		shifted.append(point + Vector2(offset, offset))
	draw_colored_polygon(shifted, shadow)
	draw_colored_polygon(points, paper)
	draw_polyline(points, Color("fff7e7", 0.58), 2.0, true)

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var paper_theme := Theme.new()
	var cjk_font := FontFile.new()
	if cjk_font.load_dynamic_font("res://assets/fonts/NotoSansTC-Variable.ttf") == OK:
		paper_theme.default_font = cjk_font
		paper_theme.set_font("font", "Label", cjk_font)
		paper_theme.set_font("font", "Button", cjk_font)
	else:
		push_warning("Noto Sans TC could not be loaded; CJK text may not display.")
	paper_theme.set_color("font_color", "Label", Color("34443d"))
	paper_theme.set_color("font_color", "Button", Color("34443d"))
	paper_theme.set_stylebox("normal", "Button", _paper_style(Color("e6d8bb"), Color("9d704e"), 2, 7))
	paper_theme.set_stylebox("hover", "Button", _paper_style(Color("f2e5ca"), Color("a66a42"), 3, 7))
	paper_theme.set_stylebox("pressed", "Button", _paper_style(Color("c9d5c3"), Color("718f78"), 2, 7))
	paper_theme.set_stylebox("focus", "Button", _paper_style(Color("00000000"), Color("a66a42"), 2, 7))
	hud = VBoxContainer.new()
	hud.theme = paper_theme
	hud.position = Vector2(28, 20)
	hud.add_theme_constant_override("separation", 5)
	layer.add_child(hud)
	_add_model_preview(layer)
	notice_label = Label.new()
	notice_label.theme = paper_theme
	notice_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	notice_label.position = Vector2(-330, -64)
	notice_label.size = Vector2(660, 40)
	notice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice_label.add_theme_color_override("font_color", Color("34443d"))
	notice_label.add_theme_font_size_override("font_size", 18)
	layer.add_child(notice_label)
	travel_button = Button.new()
	travel_button.theme = paper_theme
	travel_button.position = Vector2(28, 650)
	travel_button.size = Vector2(230, 46)
	travel_button.text = "前往發光貨桌"
	travel_button.pressed.connect(_on_travel_pressed)
	layer.add_child(travel_button)
	overlay = ColorRect.new()
	overlay.color = Color(0.18, 0.23, 0.19, 0.62)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	layer.add_child(overlay)
	panel = PanelContainer.new()
	panel.theme = paper_theme
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-365, -285)
	panel.size = Vector2(730, 570)
	panel.add_theme_stylebox_override("panel", _paper_style(Color("f5ecd8"), Color("a66a42"), 5, 10))
	panel.visible = false
	layer.add_child(panel)

func _paper_style(fill: Color, border: Color, width: int, shadow_size: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(5)
	style.shadow_color = Color("594e3d", 0.22)
	style.shadow_size = shadow_size
	style.shadow_offset = Vector2(3, 4)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _add_model_preview(layer: CanvasLayer) -> void:
	var display := SubViewportContainer.new()
	display.position = Vector2(1000, 16)
	display.size = Vector2(245, 130)
	display.stretch = true
	display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(display)
	prop_view = SubViewport.new()
	prop_view.size = Vector2i(490, 260)
	prop_view.transparent_bg = true
	prop_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	display.add_child(prop_view)
	var world := Node3D.new()
	prop_view.add_child(world)
	var env_node := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0, 0, 0, 0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("a3b4cf")
	env.ambient_light_energy = 1.0
	env_node.environment = env
	world.add_child(env_node)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-35, -25, 0)
	light.light_energy = 2.0
	world.add_child(light)
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 5.7
	camera.position = Vector3(4, -8, 4.2)
	world.add_child(camera)
	camera.look_at(Vector3(0.7, 0, 0.4))
	camera.current = true
	# Load the Blender GLB through Godot's GLTF API, so first launch works
	# even when the editor has not yet created its .godot import cache.
	var gltf := GLTFDocument.new()
	var gltf_state := GLTFState.new()
	var result := gltf.append_from_file("res://assets/little_dream_props.glb", gltf_state)
	if result == OK:
		var model := gltf.generate_scene(gltf_state)
		if model:
			world.add_child(model)
			model.position = Vector3(0, 0, 0)
			model.scale = Vector3.ONE * 1.5

func refresh_hud() -> void:
	if not is_instance_valid(hud): return
	for child in hud.get_children(): child.queue_free()
	var level_name := "儲蓄規劃" if stage == 0 else "投資與風險"
	var key_text := "已取得" if solved[stage] else "尚未取得"
	var rows := [
		"小小夢魔｜星港理財迷航",
		"第 %d / 2 關　%s" % [stage + 1, level_name],
		"本關 %d 分　｜　總分 %d / 200　｜　本關星鑰：%s" % [scores[stage], scores[0] + scores[1], key_text],
		"A / D 或 ← / → 移動　　靠近貨桌按 E 配置星幣"
	]
	for i in rows.size():
		var label := Label.new()
		label.text = rows[i]
		label.add_theme_color_override("font_color", [Color("34443d"), Color("52665b"), Color("a66a42"), Color("68736a")][i])
		if i == 0: label.add_theme_font_size_override("font_size", 23)
		hud.add_child(label)
	if is_instance_valid(notice_label):
		notice_label.text = notice if notice_time > 0.0 else ""
	if is_instance_valid(travel_button):
		travel_button.text = "前往發光貨桌" if not solved[stage] else ("前往第二關" if stage == 0 else "查看成長紀錄")

func open_interaction() -> void:
	if solved[stage]:
		set_notice("星鑰已到手，往右邊艙門前進！")
		return
	active = true
	travel_button.visible = false
	overlay.visible = true
	_build_lesson_panel()
	panel.visible = true
	refresh_allocation_display()

func _build_lesson_panel() -> void:
	for child in panel.get_children(): child.queue_free()
	lesson_box = VBoxContainer.new()
	lesson_box.theme = panel.theme
	lesson_box.add_theme_constant_override("separation", 11)
	panel.add_child(lesson_box)
	var title := Label.new()
	title.text = LESSON_TITLES[stage]
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color("a35435"))
	lesson_box.add_child(title)
	var prompt := Label.new()
	prompt.text = LESSON_PROMPTS[stage]
	prompt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt.custom_minimum_size.x = 680
	lesson_box.add_child(prompt)
	var rule := Label.new()
	rule.text = LESSON_RULES[stage]
	rule.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rule.add_theme_color_override("font_color", Color("52665b"))
	lesson_box.add_child(rule)
	total_label = Label.new()
	total_label.add_theme_font_size_override("font_size", 20)
	total_label.add_theme_color_override("font_color", Color("718f78"))
	lesson_box.add_child(total_label)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	lesson_box.add_child(row)
	allocation_labels.clear()
	for index in range(3):
		var card := PanelContainer.new()
		card.theme = panel.theme
		card.add_theme_stylebox_override("panel", _paper_style(Color("eee3ca"), Color("91a78d"), 2, 5))
		card.custom_minimum_size = Vector2(215, 145)
		row.add_child(card)
		var column := VBoxContainer.new()
		column.alignment = BoxContainer.ALIGNMENT_CENTER
		column.add_theme_constant_override("separation", 8)
		card.add_child(column)
		var name_label := Label.new()
		name_label.text = BOX_NAMES[stage][index]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		column.add_child(name_label)
		var count_label := Label.new()
		count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		count_label.add_theme_font_size_override("font_size", 26)
		column.add_child(count_label)
		allocation_labels.append(count_label)
		var controls := HBoxContainer.new()
		controls.alignment = BoxContainer.ALIGNMENT_CENTER
		column.add_child(controls)
		var minus := Button.new()
		minus.text = "−　取回"
		minus.custom_minimum_size = Vector2(94, 38)
		minus.pressed.connect(_change_allocation.bind(index, -1))
		controls.add_child(minus)
		var plus := Button.new()
		plus.text = "+　裝箱"
		plus.custom_minimum_size = Vector2(94, 38)
		plus.pressed.connect(_change_allocation.bind(index, 1))
		controls.add_child(plus)
	feedback_label = Label.new()
	feedback_label.text = "選擇每個貨箱的星幣數量，再按「確認配置」。"
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feedback_label.custom_minimum_size.y = 40
	lesson_box.add_child(feedback_label)
	submit_button = Button.new()
	submit_button.text = "確認配置，挑戰通關"
	submit_button.custom_minimum_size = Vector2(680, 48)
	submit_button.pressed.connect(_submit_allocation)
	lesson_box.add_child(submit_button)
	var cancel := Button.new()
	cancel.text = "先離開貨桌"
	cancel.pressed.connect(_close_panel)
	lesson_box.add_child(cancel)

func _change_allocation(index: int, amount: int) -> void:
	var next_value: int = allocations[stage][index] + amount
	if next_value < 0 or _allocated_total() + amount > TOTALS[stage]: return
	allocations[stage][index] = next_value
	feedback_label.text = "配置可以調整。確認前先看看總數與每個貨箱的規則。"
	refresh_allocation_display()

func _allocated_total() -> int:
	var sum := 0
	for value in allocations[stage]: sum += value
	return sum

func refresh_allocation_display() -> void:
	if not is_instance_valid(total_label): return
	total_label.text = "已裝箱 %d / %d 枚星幣" % [_allocated_total(), TOTALS[stage]]
	for i in range(allocation_labels.size()):
		allocation_labels[i].text = "%d 枚星幣" % allocations[stage][i]

func _submit_allocation() -> void:
	if _allocated_total() != TOTALS[stage]:
		feedback_label.text = "星幣總數還不正確，請補齊或取回後再確認。這次調整不扣分。"
		feedback_label.add_theme_color_override("font_color", Color("a35435"))
		return
	var valid := false
	if stage == 0:
		var saved: int = allocations[0][0]
		var needs: int = allocations[0][1]
		var wants: int = allocations[0][2]
		valid = saved >= 3 and needs >= 5 and wants <= 2
	else:
		var used_boxes := 0
		for amount in allocations[1]:
			if amount > 0: used_boxes += 1
			if amount > 6: valid = false
		valid = used_boxes >= 2
		for amount in allocations[1]:
			if amount > 6: valid = false
	if not valid:
		_mistake(WRONG_HINTS[stage], "這個配置還不能取得星鑰。讀一讀條件，調整貨箱後再試。")
		return
	solved[stage] = true
	scores[stage] = maxi(40, 100 - mistakes[stage] * 25)
	_close_panel()
	refresh_hud()
	set_notice("配置穩當！你取得本關星鑰。往右邊艙門前進！")
	if stage == 1:
		set_notice("分散配置成功！第二把星鑰入手，前往出口查看成長紀錄。")
	queue_redraw()

func _mistake(hint: String, message: String) -> void:
	mistakes[stage] += 1
	scores[stage] = maxi(40, 100 - mistakes[stage] * 25)
	feedback_label.text = "%s\n提示：%s\n本關目前得分：%d" % [message, hint, scores[stage]]
	feedback_label.add_theme_color_override("font_color", Color("a35435"))
	refresh_hud()

func _close_panel() -> void:
	active = false
	overlay.visible = false
	panel.visible = false
	if is_instance_valid(travel_button): travel_button.visible = true
	for child in panel.get_children(): child.queue_free()
	allocation_labels.clear()
	total_label = null
	feedback_label = null
	submit_button = null

func set_notice(message: String) -> void:
	notice = message
	notice_time = 7.0
	if is_instance_valid(notice_label): notice_label.text = notice

func _on_travel_pressed() -> void:
	if not solved[stage]:
		player_x = 900.0
		open_interaction()
		queue_redraw()
		return
	_travel_forward()

func _travel_forward() -> void:
	if stage == 0:
		stage = 1
		player_x = 75.0
		set_notice("鑰匙打開了下一個貨艙！配置第二關的星幣。")
		refresh_hud()
		queue_redraw()
	else:
		show_ending()

func show_ending() -> void:
	finished = true
	active = true
	travel_button.visible = false
	overlay.visible = true
	for child in panel.get_children(): child.queue_free()
	var result := VBoxContainer.new()
	result.theme = panel.theme
	result.add_theme_constant_override("separation", 16)
	panel.add_child(result)
	var title := Label.new()
	title.text = "穿越星港迷霧｜理財成長紀錄"
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color("a35435"))
	result.add_child(title)
	var details := Label.new()
	details.text = "第一關｜儲蓄規劃：%d / 100\n第二關｜分散投資：%d / 100\n總分：%d / 200\n\n學習進度：完成 2 / 2 個互動單元\n\n你練習先滿足需要、保留儲蓄，再把投資分散到不同選項。每次調整配置，都是讓未來更穩健的一小步。" % [scores[0], scores[1], scores[0] + scores[1]]
	details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.add_child(details)
	var again := Button.new()
	again.text = "重新開始旅程"
	again.custom_minimum_size = Vector2(680, 48)
	again.pressed.connect(_restart)
	result.add_child(again)
	panel.visible = true
	refresh_hud()

func _restart() -> void:
	stage = 0
	player_x = 130.0
	active = false
	finished = false
	solved = [false, false]
	scores = [0, 0]
	mistakes = [0, 0]
	allocations = [[0, 0, 0], [0, 0, 0]]
	_close_panel()
	set_notice("用 A / D 或方向鍵走到發光貨桌旁，按 E 開始配置。")
	refresh_hud()
	queue_redraw()
