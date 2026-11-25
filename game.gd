extends Node2D

const STAGE_TITLES := ["理財配置桌", "上學購物", "理財紅綠燈", "突發支出情境"]
const BUDGET_CATEGORIES := ["需要", "想要", "儲蓄", "投資"]
const SHOP_ITEMS := [
	{"store":"早餐店", "name":"飯糰早餐", "kind":"需要", "why":"早餐補充上課體力；先確認有沒有吃早餐的需求。"},
	{"store":"早餐店", "name":"加料豪華套餐", "kind":"想要", "why":"基本早餐已足夠時，額外加料屬於想要，可以比較價差再決定。"},
	{"store":"早餐店", "name":"瓶裝飲料", "kind":"想要", "why":"若能帶水壺或喝白開水，這瓶飲料通常不是必要支出。"},
	{"store":"便利商店", "name":"明天要交的筆記本", "kind":"需要", "why":"課堂作業必需而手邊沒有替代品時，這是學習需要。"},
	{"store":"便利商店", "name":"限量盲盒", "kind":"想要", "why":"限量促銷會讓人著急，但收藏品不是完成學校任務的必要支出。"},
	{"store":"便利商店", "name":"第二份零食", "kind":"想要", "why":"已經有點心時，多買一份可以先想一想是否真的需要。"},
	{"store":"傳統雜貨店", "name":"家裡指定的雞蛋", "kind":"需要", "why":"依照家人交代購買日常食材，是生活中的實際需要。"},
	{"store":"傳統雜貨店", "name":"替換用文具", "kind":"需要", "why":"原本的文具用完且課堂需要時，購買平價替用品很合理。"},
	{"store":"傳統雜貨店", "name":"新款造型貼紙", "kind":"想要", "why":"已有可用的貼紙時，新款主要帶來喜好與新鮮感，屬於想要。"}
]
const TRAFFIC_QUESTIONS := [
	{"situation":"同學分享一款流行耳機，今天下單才有折扣；你的耳機仍能正常使用。", "answer":"想一想", "why":"先比較價格、品質與預算，折扣不代表現在一定要買。"},
	{"situation":"下週要交報告，你的筆記本已經寫滿，家中也沒有可替代的紙本。", "answer":"立刻買", "why":"這是近期明確的學習需要，選擇符合預算的款式即可。"},
	{"situation":"你想買一款較貴的遊戲，零用錢還不夠，生日也在兩個月後。", "answer":"先存錢", "why":"先訂目標、分次存下來，不借錢也不挪用必要支出。"},
	{"situation":"看到限時貼文說球鞋只剩最後一雙，但你已有一雙合腳、堪用的鞋。", "answer":"想一想", "why":"倒數訊息會增加衝動；先離開頁面並檢查需求與預算。"},
	{"situation":"明天校外教學要搭車，老師通知需自備車資，你目前還沒準備。", "answer":"立刻買", "why":"已知且必要的交通費應先安排，並確認金額和安全保管方式。"},
	{"situation":"你想買新出的漫畫整套，手上存款還有其他已約好的用途。", "answer":"先存錢", "why":"先保留已承諾的用途，再為漫畫設定存錢目標與期限。"}
]
const EMERGENCY_SITUATION := "校外教學前一天，眼鏡不小心摔壞，修理需要 600 元。你有 1,000 元零用錢：其中 500 元是預計買球鞋的儲蓄，200 元是下週交通費，300 元是緊急預備金。"
const EMERGENCY_CHOICES := ["先用 300 元預備金，再和家人討論其餘 300 元", "把下週交通費和所有儲蓄都花掉", "先買球鞋，眼鏡等下個月再處理"]
const EMERGENCY_ANSWER := 0
const EMERGENCY_WHY := "眼鏡影響上課與安全，屬於優先處理的必要支出。先動用預備金、說明差額並和可信任的大人討論；保留交通等已安排用途，也重新規劃球鞋目標。"

var stage := 0
var player_x := 130.0
var active := false
var finished := false
var solved := [false, false, false, false]
var scores := [0, 0, 0, 0]
var mistakes := [0, 0, 0, 0]
var budget := [0, 0, 0, 0]
var shopping_index := 0
var traffic_index := 0
var notice := "走到互動桌旁按 E 開始，或按左下角按鈕前往。"
var notice_time := 10.0

var hud: VBoxContainer
var overlay: ColorRect
var panel: PanelContainer
var lesson_box: VBoxContainer
var feedback_label: Label
var action_button: Button
var choice_box: VBoxContainer
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
	if not is_zero_approx(direction):
		player_x = clampf(player_x + direction * 245.0 * delta, 45.0, 1235.0)
		queue_redraw()
	if Input.is_key_pressed(KEY_E) and absf(player_x - 900.0) < 210.0:
		open_interaction()
	if player_x > 1210.0 and solved[stage]:
		_travel_forward()

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
	# Bright, original isometric starport island with a lagoon and tiny market.
	draw_rect(Rect2(0, 0, 1280, 720), Color("65c9c5"))
	for i in range(34):
		var wx := float((i * 173 + 47) % 1260)
		var wy := float((i * 97 + 30) % 700)
		_draw_oval(Vector2(wx, wy), 13.0 + float(i % 4) * 3.0, 2.2, Color("b4eee1", 0.40))
	# Floating island edge and sunlit grassy top.
	var cliff := PackedVector2Array([Vector2(-60, 324), Vector2(78, 208), Vector2(270, 158), Vector2(463, 181), Vector2(620, 132), Vector2(825, 162), Vector2(1035, 180), Vector2(1272, 268), Vector2(1345, 400), Vector2(1288, 565), Vector2(1110, 660), Vector2(940, 691), Vector2(740, 740), Vector2(480, 716), Vector2(258, 662), Vector2(78, 581), Vector2(-40, 465)])
	draw_colored_polygon(cliff, Color("ae8757"))
	var grass_edge := PackedVector2Array([Vector2(-65, 300), Vector2(74, 186), Vector2(268, 135), Vector2(464, 158), Vector2(620, 112), Vector2(825, 143), Vector2(1035, 158), Vector2(1276, 246), Vector2(1332, 377), Vector2(1275, 540), Vector2(1098, 635), Vector2(927, 664), Vector2(733, 710), Vector2(478, 688), Vector2(255, 632), Vector2(72, 550), Vector2(-55, 438)])
	draw_colored_polygon(grass_edge, Color("8de09c"))
	# Dappled meadow patches.
	for i in range(72):
		var gx := float((i * 139 + 95) % 1260)
		var gy := float(215 + (i * 83 + 30) % 410)
		var tint: Color = [Color("a8e9a4", 0.55), Color("d0ef9b", 0.48), Color("72cd86", 0.38)][i % 3]
		_draw_oval(Vector2(gx, gy), 24.0 + float(i % 5) * 4.0, 6.5, tint)
	# Pebbled shoreline around the island.
	for i in range(25):
		var rx := float(i * 53 - 20)
		var ry := 330.0 + sin(float(i) * 0.43) * 95.0
		_draw_oval(Vector2(rx, ry), 15.0 + float(i % 3) * 3.0, 9.0, [Color("f5dfb1"), Color("d8c59a"), Color("fff0cb")][i % 3])
	# Winding cream footpaths connect the four learning stops.
	var path := PackedVector2Array([Vector2(130, 574), Vector2(275, 522), Vector2(415, 552), Vector2(558, 490), Vector2(700, 510), Vector2(838, 450), Vector2(1010, 461), Vector2(1170, 403)])
	draw_polyline(path, Color("c4b47c", 0.42), 42.0, true)
	draw_polyline(path, Color("fff1c7"), 31.0, true)
	# Original little gardens, tents, kiosks and companion critters.
	_draw_garden(Vector2(334, 338), 1.0)
	_draw_garden(Vector2(522, 287), 0.83)
	_draw_tree(Vector2(155, 344), 0.90, Color("33aa78"))
	_draw_tree(Vector2(678, 213), 0.74, Color("60c887"))
	_draw_tree(Vector2(1118, 326), 0.92, Color("ed9caf"))
	_draw_tree(Vector2(1050, 542), 0.74, Color("348f73"))
	_draw_kiosk(Vector2(522, 448), Color("efb65a"), Color("fff1c9"), "★")
	_draw_kiosk(Vector2(728, 367), Color("42b6c0"), Color("e7fbf1"), "早餐")
	_draw_kiosk(Vector2(910, 408), Color("ef9270"), Color("fff0d5"), "便利")
	_draw_kiosk(Vector2(1070, 456), Color("8674cf"), Color("f4e9ff"), "雜貨")
	_draw_helper(Vector2(448, 510), Color("fff1d0"), Color("ef8b55"))
	_draw_helper(Vector2(790, 480), Color("e3f4ec"), Color("42aeb2"))
	_draw_helper(Vector2(1003, 526), Color("fff0df"), Color("9775cf"))
	_draw_landmark()
	# The traveler moves along the lower path; a glowing marker shows the interaction point.
	_draw_oval(Vector2(900, 501), 47, 13, Color("fff1a9", 0.45))
	_draw_character(Vector2(player_x, 536))

func _draw_oval(center: Vector2, rx: float, ry: float, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(25):
		var angle := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(angle) * rx, sin(angle) * ry))
	draw_colored_polygon(points, color)

func _draw_diamond(center: Vector2, width: float, height: float, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([center + Vector2(0, -height * 0.5), center + Vector2(width * 0.5, 0), center + Vector2(0, height * 0.5), center + Vector2(-width * 0.5, 0)]), color)

func _draw_tree(base: Vector2, scale: float, crown: Color) -> void:
	_draw_oval(base + Vector2(3, 3), 35 * scale, 11 * scale, Color("458d5f", 0.25))
	draw_polygon(PackedVector2Array([base + Vector2(-9 * scale, 0), base + Vector2(9 * scale, 0), base + Vector2(7 * scale, -61 * scale), base + Vector2(-5 * scale, -65 * scale)]), PackedColorArray([Color("a46e43"), Color("8e5a39"), Color("b9824e"), Color("a46e43")]))
	_draw_oval(base + Vector2(-9 * scale, -63 * scale), 28 * scale, 24 * scale, crown.darkened(0.08))
	_draw_oval(base + Vector2(12 * scale, -78 * scale), 30 * scale, 27 * scale, crown)
	_draw_oval(base + Vector2(-1 * scale, -91 * scale), 25 * scale, 22 * scale, crown.lightened(0.12))
	_draw_oval(base + Vector2(16 * scale, -63 * scale), 18 * scale, 17 * scale, crown.lightened(0.08))

func _draw_garden(center: Vector2, scale: float) -> void:
	_draw_diamond(center + Vector2(5, 16), 142 * scale, 57 * scale, Color("a57546"))
	_draw_diamond(center, 137 * scale, 53 * scale, Color("f1d5a1"))
	_draw_diamond(center + Vector2(0, -3), 119 * scale, 42 * scale, Color("75c96f"))
	for row in range(3):
		for col in range(4):
			var p := center + Vector2((float(col) - 1.5) * 24 * scale, (float(row) - 1.0) * 10 * scale - 5)
			_draw_oval(p, 6 * scale, 4 * scale, [Color("3d9b61"), Color("55ad5e"), Color("76bf62")][(row + col) % 3])
			_draw_oval(p + Vector2(2, -4 * scale), 3 * scale, 4 * scale, Color("bfe37d"))

func _draw_kiosk(base: Vector2, roof: Color, wall: Color, sign: String) -> void:
	_draw_oval(base + Vector2(0, 21), 74, 20, Color("4b8f70", 0.25))
	_draw_diamond(base + Vector2(0, 9), 125, 48, Color("e8d59c"))
	draw_colored_polygon(PackedVector2Array([base + Vector2(-42, 0), base + Vector2(0, 18), base + Vector2(0, -49), base + Vector2(-42, -66)]), wall.darkened(0.10))
	draw_colored_polygon(PackedVector2Array([base + Vector2(0, 18), base + Vector2(43, 0), base + Vector2(43, -64), base + Vector2(0, -49)]), wall)
	draw_colored_polygon(PackedVector2Array([base + Vector2(-51, -62), base + Vector2(0, -86), base + Vector2(53, -64), base + Vector2(0, -39)]), roof)
	draw_colored_polygon(PackedVector2Array([base + Vector2(-51, -62), base + Vector2(-51, -53), base + Vector2(0, -29), base + Vector2(0, -39)]), roof.darkened(0.14))
	draw_colored_polygon(PackedVector2Array([base + Vector2(0, -39), base + Vector2(0, -29), base + Vector2(53, -54), base + Vector2(53, -64)]), roof.darkened(0.08))
	draw_rect(Rect2(base + Vector2(-27, -43), Vector2(18, 27)), Color("8bd7d2"))
	draw_rect(Rect2(base + Vector2(8, -41), Vector2(18, 24)), Color("fff4cc"))
	draw_rect(Rect2(base + Vector2(-1, -47), Vector2(3, 38)), Color("fff4cc"))
	_draw_oval(base + Vector2(0, -71), 25, 12, Color("fff8dc"))
	# Sign is intentionally icon-like and uses no copied logo.
	draw_circle(base + Vector2(0, -72), 7, Color("e9aa43"))

func _draw_helper(base: Vector2, fur: Color, accent: Color) -> void:
	_draw_oval(base + Vector2(1, 4), 16, 6, Color("456e60", 0.22))
	_draw_oval(base + Vector2(0, -11), 12, 12, fur)
	_draw_oval(base + Vector2(-7, -21), 5, 7, fur)
	_draw_oval(base + Vector2(7, -21), 5, 7, fur)
	draw_circle(base + Vector2(-4, -12), 1.7, Color("34443d"))
	draw_circle(base + Vector2(4, -12), 1.7, Color("34443d"))
	draw_circle(base + Vector2(0, -7), 2.0, accent)

func _draw_character(base: Vector2) -> void:
	_draw_oval(base + Vector2(0, 3), 20, 7, Color("426b58", 0.28))
	draw_line(base + Vector2(-6, -7), base + Vector2(-9, 2), Color("62493b"), 4)
	draw_line(base + Vector2(6, -7), base + Vector2(9, 2), Color("62493b"), 4)
	_draw_oval(base + Vector2(0, -31), 17, 23, Color("f08a51"))
	_draw_oval(base + Vector2(0, -55), 13, 13, Color("f3c79c"))
	draw_colored_polygon(PackedVector2Array([base + Vector2(-12, -61), base + Vector2(-6, -81), base + Vector2(2, -69), base + Vector2(13, -80), base + Vector2(11, -58)]), Color("41aeb7"))
	draw_circle(base + Vector2(-4, -55), 1.4, Color("3e534c"))
	draw_circle(base + Vector2(4, -55), 1.4, Color("3e534c"))

func _draw_landmark() -> void:
	match stage:
		0:
			_draw_diamond(Vector2(554, 430), 92, 45, Color("69c3b4"))
			_draw_diamond(Vector2(554, 414), 74, 36, Color("daf1d1"))
			_draw_oval(Vector2(554, 410), 23, 10, Color("f4cb65"))
		1:
			for i in range(3):
				var x := 722.0 + i * 180.0
				_draw_diamond(Vector2(x, 400 + i * 12), 36, 17, Color("fff1c5"))
				draw_rect(Rect2(x - 3, 383 + i * 12, 6, 20), Color("f39a59"))
				draw_circle(Vector2(x, 379 + i * 12), 9, Color("f3cc58"))
		2:
			_draw_diamond(Vector2(904, 358), 108, 49, Color("e7d3a2"))
			draw_rect(Rect2(860, 288, 88, 70), Color("f9f0d7"))
			for i in range(3): draw_circle(Vector2(882 + i * 21, 310), 8, [Color("ef6962"), Color("f5c84c"), Color("6acb77")][i])
		3:
			_draw_kiosk(Vector2(903, 368), Color("68c9a1"), Color("f5eed9"), "+")
			_draw_diamond(Vector2(993, 452), 65, 28, Color("eab957"))
			_draw_diamond(Vector2(993, 441), 56, 24, Color("ffdc78"))

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
	paper_theme.set_color("font_color", "Label", Color("173c3c"))
	paper_theme.set_color("font_color", "Button", Color("173c3c"))
	paper_theme.set_stylebox("normal", "Button", _paper_style(Color("fffdf4"), Color("38a99c"), 2, 7))
	paper_theme.set_stylebox("hover", "Button", _paper_style(Color("e1f8dc"), Color("248e84"), 3, 7))
	paper_theme.set_stylebox("pressed", "Button", _paper_style(Color("bcebd1"), Color("238777"), 2, 7))
	paper_theme.set_stylebox("focus", "Button", _paper_style(Color("fffdf4"), Color("ee9a58"), 3, 7))
	paper_theme.set_font_size("font_size", "Label", 17)
	paper_theme.set_font_size("font_size", "Button", 17)
	var hud_card := PanelContainer.new()
	hud_card.theme = paper_theme
	hud_card.position = Vector2(18, 14)
	hud_card.size = Vector2(500, 152)
	hud_card.custom_minimum_size = Vector2(500, 152)
	hud_card.add_theme_stylebox_override("panel", _paper_style(Color("fffdf4", 0.97), Color("ffffff", 0.88), 2, 9))
	layer.add_child(hud_card)
	hud = VBoxContainer.new()
	hud.theme = paper_theme
	hud.add_theme_constant_override("separation", 4)
	hud_card.add_child(hud)
	_add_model_preview(layer)
	var notice_card := PanelContainer.new()
	notice_card.theme = paper_theme
	notice_card.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	notice_card.position = Vector2(-390, -84)
	notice_card.size = Vector2(780, 43)
	notice_card.add_theme_stylebox_override("panel", _paper_style(Color("fffdf4", 0.97), Color("ffffff", 0.80), 2, 6))
	notice_label = Label.new()
	notice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice_label.add_theme_color_override("font_color", Color("173c3c"))
	notice_label.add_theme_font_size_override("font_size", 16)
	notice_card.add_child(notice_label)
	layer.add_child(notice_card)
	travel_button = Button.new()
	travel_button.theme = paper_theme
	travel_button.position = Vector2(28, 650)
	travel_button.size = Vector2(246, 50)
	travel_button.text = "前往理財互動桌"
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
	panel.position = Vector2(-410, -290)
	panel.size = Vector2(820, 580)
	panel.add_theme_stylebox_override("panel", _paper_style(Color("f5ecd8"), Color("a66a42"), 5, 10))
	panel.visible = false
	layer.add_child(panel)

func _paper_style(fill: Color, border: Color, width: int, shadow_size: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(18)
	style.shadow_color = Color("594e3d", 0.22)
	style.shadow_size = shadow_size
	style.shadow_offset = Vector2(3, 4)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _add_model_preview(layer: CanvasLayer) -> void:
	var prop_card := PanelContainer.new()
	prop_card.position = Vector2(1000, 12)
	prop_card.size = Vector2(258, 145)
	prop_card.add_theme_stylebox_override("panel", _paper_style(Color("fffdf4", 0.97), Color("ffffff", 0.88), 2, 9))
	layer.add_child(prop_card)
	var display := SubViewportContainer.new()
	display.position = Vector2(1005, 17)
	display.size = Vector2(248, 130)
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
	var level_name: String = STAGE_TITLES[stage]
	var total_score := 0
	for score in scores: total_score += score
	var title := Label.new()
	title.text = "星港理財局｜零用錢任務"
	title.add_theme_color_override("font_color", Color("173c3c"))
	title.add_theme_font_size_override("font_size", 23)
	hud.add_child(title)
	var stage_label := Label.new()
	stage_label.text = "單元 %d / 4　%s" % [stage + 1, level_name]
	stage_label.add_theme_color_override("font_color", Color("256b63"))
	stage_label.add_theme_font_size_override("font_size", 17)
	hud.add_child(stage_label)
	var progress := ProgressBar.new()
	progress.min_value = 0
	progress.max_value = 4
	progress.value = solved.count(true)
	progress.show_percentage = false
	progress.custom_minimum_size.y = 16
	var progress_bg := StyleBoxFlat.new()
	progress_bg.bg_color = Color("d9ead7")
	progress_bg.set_corner_radius_all(8)
	var progress_fill := StyleBoxFlat.new()
	progress_fill.bg_color = Color("54c66d")
	progress_fill.set_corner_radius_all(8)
	progress.add_theme_stylebox_override("background", progress_bg)
	progress.add_theme_stylebox_override("fill", progress_fill)
	hud.add_child(progress)
	var score_line := Label.new()
	score_line.text = "本單元 %d / 100　　累計 %d / 400　　星鑰 %d / 4" % [scores[stage], total_score, solved.count(true)]
	score_line.add_theme_color_override("font_color", Color("214d49"))
	score_line.add_theme_font_size_override("font_size", 15)
	hud.add_child(score_line)
	if is_instance_valid(notice_label):
		notice_label.text = notice if notice_time > 0.0 else ""
	if is_instance_valid(travel_button):
		travel_button.text = "前往理財互動桌" if not solved[stage] else ("前往下一單元" if stage < 3 else "查看成長紀錄")

func open_interaction() -> void:
	if solved[stage]:
		set_notice("本單元星鑰已取得，按左下角按鈕繼續！")
		return
	active = true
	travel_button.visible = false
	overlay.visible = true
	_build_lesson_panel()
	panel.visible = true

func _build_lesson_panel() -> void:
	for child in panel.get_children(): child.queue_free()
	lesson_box = VBoxContainer.new()
	lesson_box.theme = panel.theme
	lesson_box.add_theme_constant_override("separation", 11)
	panel.add_child(lesson_box)
	var title := Label.new()
	title.text = "單元 %d｜%s" % [stage + 1, STAGE_TITLES[stage]]
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color("a35435"))
	lesson_box.add_child(title)
	var prompt := Label.new()
	prompt.text = [
		"請把 100% 的每月零用錢分配到四類。想想近期生活、想買的物品、未來目標，以及投資可能有損失。",
		"依序逛早餐店、便利商店、傳統雜貨店。每件商品請判斷是「需要」或「想要」，結帳後會看到理由。",
		"閱讀 6 個生活情境，選擇「立刻買」、「想一想」或「先存錢」。每題選完會說明判斷線索。",
		EMERGENCY_SITUATION
	][stage]
	prompt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt.custom_minimum_size.x = 770
	lesson_box.add_child(prompt)
	feedback_label = Label.new()
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feedback_label.custom_minimum_size.y = 50
	lesson_box.add_child(feedback_label)
	choice_box = VBoxContainer.new()
	choice_box.add_theme_constant_override("separation", 7)
	lesson_box.add_child(choice_box)
	action_button = Button.new()
	action_button.custom_minimum_size = Vector2(770, 44)
	lesson_box.add_child(action_button)
	var cancel := Button.new()
	cancel.text = "暫停，稍後繼續"
	cancel.pressed.connect(_close_panel)
	lesson_box.add_child(cancel)
	match stage:
		0: _build_budget_task()
		1: _build_shopping_task()
		2: _build_traffic_task()
		3: _build_emergency_task()

func _build_budget_task() -> void:
	var guidance := Label.new()
	guidance.text = "參考範圍：需要 35–60%｜想要 0–25%｜儲蓄至少 15%｜投資 5–25%。投資有風險，不保證獲利；配置不只一種答案。"
	guidance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lesson_box.add_child(guidance)
	for index in range(BUDGET_CATEGORIES.size()):
		var row := HBoxContainer.new()
		lesson_box.add_child(row)
		var label := Label.new()
		label.text = BUDGET_CATEGORIES[index]
		label.custom_minimum_size.x = 100
		row.add_child(label)
		var slider := HSlider.new()
		slider.min_value = 0
		slider.max_value = 100
		slider.step = 5
		slider.value = budget[index]
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_set_budget.bind(index))
		row.add_child(slider)
		var value_label := Label.new()
		value_label.name = "BudgetValue%d" % index
		value_label.text = "%d%%" % budget[index]
		value_label.custom_minimum_size.x = 60
		row.add_child(value_label)
	feedback_label.text = "目前配置合計 %d%%。可拖動滑桿調整。" % _budget_total()
	action_button.text = "檢查我的配置"
	action_button.pressed.connect(_check_budget)

func _set_budget(value: float, index: int) -> void:
	budget[index] = int(value)
	var value_label := lesson_box.find_child("BudgetValue%d" % index, true, false) as Label
	if value_label: value_label.text = "%d%%" % budget[index]
	feedback_label.text = "目前配置合計 %d%%，請把每一部分安排好。" % _budget_total()

func _budget_total() -> int:
	var total := 0
	for amount in budget: total += amount
	return total

func _check_budget() -> void:
	if _budget_total() != 100:
		feedback_label.text = "目前合計 %d%%，請調整到剛好 100%%。這是檢查提醒，不扣分。" % _budget_total()
		return
	var valid: bool = budget[0] >= 35 and budget[0] <= 60 and budget[1] <= 25 and budget[2] >= 15 and budget[3] >= 5 and budget[3] <= 25
	if not valid:
		_mistake("先保留基本生活需要與儲蓄，再看想要與投資是否落在參考範圍。投資可能虧損，請勿把所有錢放在同一處。")
		return
	feedback_label.text = "配置合計 100%，四個部分都顧到了。儲蓄較適合短期目標；投資要了解風險與時間。"
	_finish_stage()

func _build_shopping_task() -> void:
	shopping_index = 0
	_render_shopping_item()

func _render_shopping_item() -> void:
	for child in choice_box.get_children(): child.queue_free()
	action_button.visible = false
	var item: Dictionary = SHOP_ITEMS[shopping_index]
	var counter := Label.new()
	counter.text = "%s｜商品 %d / %d" % [item.store, shopping_index + 1, SHOP_ITEMS.size()]
	counter.add_theme_font_size_override("font_size", 21)
	choice_box.add_child(counter)
	var name_label := Label.new()
	name_label.text = item.name
	name_label.add_theme_font_size_override("font_size", 25)
	choice_box.add_child(name_label)
	feedback_label.text = "想一想：這項商品是生活或學習所需，還是主要滿足喜好？"
	for kind in ["需要", "想要"]:
		var button := Button.new()
		button.text = kind
		button.custom_minimum_size.y = 42
		button.pressed.connect(_answer_shopping.bind(kind))
		choice_box.add_child(button)

func _answer_shopping(choice: String) -> void:
	var item: Dictionary = SHOP_ITEMS[shopping_index]
	var correct: bool = choice == item.kind
	if not correct: _record_mistake()
	feedback_label.text = "%s：%s。%s%s" % ["判斷正確" if correct else "這次分類不同", item.kind, item.why, "　調整本次得分後繼續。" if not correct else ""]
	for child in choice_box.get_children():
		if child is Button: child.disabled = true
	action_button.text = "下一項商品" if shopping_index < SHOP_ITEMS.size() - 1 else "完成購物任務"
	action_button.visible = true
	if not action_button.pressed.is_connected(_next_shopping_item): action_button.pressed.connect(_next_shopping_item)

func _next_shopping_item() -> void:
	if shopping_index < SHOP_ITEMS.size() - 1:
		shopping_index += 1
		_render_shopping_item()
	else:
		feedback_label.text = "三間店都逛完了。結帳時先分辨必需與喜好，能讓預算更清楚。"
		_finish_stage()

func _build_traffic_task() -> void:
	traffic_index = 0
	_render_traffic_question()

func _render_traffic_question() -> void:
	for child in choice_box.get_children(): child.queue_free()
	action_button.visible = false
	var q: Dictionary = TRAFFIC_QUESTIONS[traffic_index]
	var count := Label.new()
	count.text = "情境 %d / %d" % [traffic_index + 1, TRAFFIC_QUESTIONS.size()]
	count.add_theme_font_size_override("font_size", 21)
	choice_box.add_child(count)
	var situation := Label.new()
	situation.text = q.situation
	situation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	choice_box.add_child(situation)
	feedback_label.text = "你會怎麼做？先讀預算、需要程度和時間線索。"
	for choice in ["立刻買", "想一想", "先存錢"]:
		var button := Button.new()
		button.text = choice
		button.custom_minimum_size.y = 38
		button.pressed.connect(_answer_traffic.bind(choice))
		choice_box.add_child(button)

func _answer_traffic(choice: String) -> void:
	var q: Dictionary = TRAFFIC_QUESTIONS[traffic_index]
	var correct: bool = choice == q.answer
	if not correct: _record_mistake()
	feedback_label.text = "%s；建議「%s」。%s%s" % ["判斷合適" if correct else "可以再想想", q.answer, q.why, "　我們一起看判斷線索。" if not correct else ""]
	for child in choice_box.get_children():
		if child is Button: child.disabled = true
	action_button.text = "下一個情境" if traffic_index < TRAFFIC_QUESTIONS.size() - 1 else "完成六個情境"
	action_button.visible = true
	if not action_button.pressed.is_connected(_next_traffic_question): action_button.pressed.connect(_next_traffic_question)

func _next_traffic_question() -> void:
	if traffic_index < TRAFFIC_QUESTIONS.size() - 1:
		traffic_index += 1
		_render_traffic_question()
	else:
		feedback_label.text = "六個情境都完成了。促銷、同儕流行和倒數訊息，都值得多看一步。"
		_finish_stage()

func _build_emergency_task() -> void:
	for index in range(EMERGENCY_CHOICES.size()):
		var button := Button.new()
		button.text = EMERGENCY_CHOICES[index]
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size.y = 50
		button.pressed.connect(_answer_emergency.bind(index))
		choice_box.add_child(button)
	feedback_label.text = "選擇處理方式，想想急用金、已安排用途與求助對象。"

func _answer_emergency(choice: int) -> void:
	var correct: bool = choice == EMERGENCY_ANSWER
	if not correct:
		_record_mistake()
		feedback_label.text = "先停一下：眼鏡會影響上課與安全。%s" % EMERGENCY_WHY
		return
	feedback_label.text = "這個處理順序兼顧安全與原有計畫。%s" % EMERGENCY_WHY
	_finish_stage()

func _record_mistake() -> void:
	mistakes[stage] += 1
	scores[stage] = maxi(0, 100 - mistakes[stage] * 10)
	refresh_hud()

func _mistake(hint: String) -> void:
	_record_mistake()
	feedback_label.text = "配置還可再調整。%s\n本單元目前得分：%d" % [hint, scores[stage]]
	feedback_label.add_theme_color_override("font_color", Color("a35435"))

func _finish_stage() -> void:
	solved[stage] = true
	scores[stage] = maxi(0, 100 - mistakes[stage] * 10)
	if stage == 0 and action_button.pressed.is_connected(_check_budget): action_button.pressed.disconnect(_check_budget)
	if stage == 1 and action_button.pressed.is_connected(_next_shopping_item): action_button.pressed.disconnect(_next_shopping_item)
	if stage == 2 and action_button.pressed.is_connected(_next_traffic_question): action_button.pressed.disconnect(_next_traffic_question)
	for child in choice_box.get_children():
		if child is Button: child.disabled = true
	if stage == 0:
		for child in lesson_box.get_children():
			if child is HBoxContainer:
				for control in child.get_children():
					if control is HSlider: control.editable = false
	if not action_button.pressed.is_connected(_advance_or_end): action_button.pressed.connect(_advance_or_end)
	action_button.text = "取得星鑰，前往下一單元" if stage < 3 else "查看理財成長成果"
	action_button.visible = true
	feedback_label.add_theme_color_override("font_color", Color("52665b"))
	feedback_label.text += "\n取得本單元星鑰！本單元得分 %d / 100。" % scores[stage]
	refresh_hud()
	queue_redraw()

func _advance_or_end() -> void:
	if stage < 3:
		stage += 1
		_close_panel()
		set_notice("星鑰已解鎖下一個理財單元，按按鈕或走到互動桌開始。")
		refresh_hud()
		queue_redraw()
	else:
		show_ending()

func _close_panel() -> void:
	active = false
	overlay.visible = false
	panel.visible = false
	if is_instance_valid(travel_button): travel_button.visible = true
	for child in panel.get_children(): child.queue_free()
	choice_box = null
	feedback_label = null
	action_button = null

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
	if solved[stage]: _advance_or_end()

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
	title.text = "星港任務完成｜理財成長報告"
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color("a35435"))
	result.add_child(title)
	var details := Label.new()
	var total_score := 0
	for score in scores: total_score += score
	details.text = "理財配置桌：%d / 100\n上學購物：%d / 100\n理財紅綠燈：%d / 100\n突發支出：%d / 100\n總分：%d / 400\n\n學習進度：完成 %d / 4 個單元\n\n你練習規劃需要、想要、儲蓄與投資，辨認購物分類，延後衝動消費，並在突發支出時先顧安全、運用預備金和尋求可信任的大人協助。" % [scores[0], scores[1], scores[2], scores[3], total_score, solved.count(true)]
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
	budget = [45, 15, 25, 15]
	shopping_index = 0
	traffic_index = 0
	_close_panel()
	set_notice("走到互動桌旁按 E 開始，或按左下角按鈕前往。")
	refresh_hud()
	queue_redraw()
