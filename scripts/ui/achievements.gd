extends Control

@onready var scroll: ScrollContainer = $Panel/VBox/ScrollContainer
@onready var back_button: Button = $Panel/VBox/BackButton

var achievement_defs := [
	{"key": "kills", "name": "击杀数", "tiers": [100, 500, 2000]},
	{"key": "total_time", "name": "总存活时长", "tiers": [10000, 50000, 200000], "suffix": "秒"},
	{"key": "total_games", "name": "游戏场数", "tiers": [10, 50, 200]},
	{"key": "no_damage_victory", "name": "无伤通关", "tiers": [1], "is_bool": true},
]

const COLOR_NONE := Color(0.18, 0.18, 0.22)
const COLOR_BRONZE := Color(0.45, 0.3, 0.15)
const COLOR_SILVER := Color(0.35, 0.35, 0.4)
const COLOR_GOLD := Color(0.5, 0.42, 0.1)

func _ready() -> void:
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn"))
	_load_achievements()

func _load_achievements() -> void:
	var record_manager = get_node_or_null("/root/RecordManager")
	if record_manager == null:
		return
	var stats: Dictionary = record_manager.get_achievements()
	var list: VBoxContainer = scroll.get_node("AchievementsList")
	for child in list.get_children():
		child.queue_free()

	for i in range(0, achievement_defs.size(), 3):
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		row.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		for c in range(3):
			if i + c >= achievement_defs.size():
				break
			var card := _create_card(achievement_defs[i + c], stats)
			row.add_child(card)
		if row.get_child_count() < 3:
			var spacer := Control.new()
			spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(spacer)
		list.add_child(row)

func _create_card(def: Dictionary, stats: Dictionary) -> PanelContainer:
	var card := PanelContainer.new()
	var current_value = stats.get(def["key"], 0)
	var is_bool: bool = def.get("is_bool", false)
	var tier_index := _get_tier_index(def, current_value, is_bool)
	var bg_color := _get_color(tier_index, is_bool)

	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.set_corner_radius_all(8)
	style.set_content_margin_all(10)
	card.add_theme_stylebox_override("panel", style)
	card.custom_minimum_size = Vector2(200, 250)
	card.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	card.add_child(vbox)

	var title := Label.new()
	title.text = def["name"]
	title.add_theme_font_size_override("font_size", 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var value_label := Label.new()
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.add_theme_font_size_override("font_size", 18)
	if is_bool:
		if bool(current_value):
			value_label.text = "已达成"
		else:
			value_label.text = "未达成"
	else:
		if tier_index >= def["tiers"].size():
			var max_val: int = def["tiers"].back()
			var suffix: String = def.get("suffix", "")
			value_label.text = "%d/%d%s" % [int(current_value), max_val, suffix]
		else:
			var next_val: int = def["tiers"][tier_index]
			var suffix: String = def.get("suffix", "")
			value_label.text = "%d/%d%s" % [mini(int(current_value), next_val), next_val, suffix]
	vbox.add_child(value_label)

	return card

func _get_tier_index(def: Dictionary, current_value, is_bool: bool) -> int:
	if is_bool:
		return 1 if bool(current_value) else 0
	for i in range(def["tiers"].size() - 1, -1, -1):
		if int(current_value) >= def["tiers"][i]:
			return i + 1
	return 0

func _get_color(tier_index: int, is_bool: bool) -> Color:
	if is_bool:
		return COLOR_GOLD if tier_index >= 1 else COLOR_NONE
	match tier_index:
		0: return COLOR_NONE
		1: return COLOR_BRONZE
		2: return COLOR_SILVER
		_: return COLOR_GOLD
