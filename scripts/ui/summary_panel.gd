extends Control

signal restart_requested
signal exit_to_menu_requested

@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var time_name: Label = $Panel/VBox/TimeRow/NameLabel
@onready var time_value: Label = $Panel/VBox/TimeRow/ValueLabel
@onready var kills_name: Label = $Panel/VBox/KillsRow/NameLabel
@onready var kills_value: Label = $Panel/VBox/KillsRow/ValueLabel
@onready var level_name: Label = $Panel/VBox/LevelRow/NameLabel
@onready var level_value: Label = $Panel/VBox/LevelRow/ValueLabel
@onready var dealt_name: Label = $Panel/VBox/DealtRow/NameLabel
@onready var dealt_value: Label = $Panel/VBox/DealtRow/ValueLabel
@onready var rewards_label: Label = $Panel/VBox/RewardsLabel
@onready var rewards_grid: GridContainer = $Panel/VBox/RewardsGrid
@onready var score_label: Label = $Panel/VBox/ScoreLabel
@onready var retry_button: Button = $Panel/VBox/RetryButton
@onready var exit_button: Button = $Panel/VBox/ExitButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	retry_button.pressed.connect(func(): restart_requested.emit())
	exit_button.pressed.connect(func(): exit_to_menu_requested.emit())

func show_summary(stats: Dictionary) -> void:
	visible = true
	var is_victory: bool = stats.get("is_victory", false)
	title_label.text = "通关！" if is_victory else "本局复盘"
	var time: float = stats.get("time", 0.0)
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	_set_row(time_name, time_value, "存活时间", "%d:%02d" % [minutes, seconds])
	_set_row(kills_name, kills_value, "击杀数量", str(stats.get("kills", 0)))
	_set_row(level_name, level_value, "最终等级", "Lv.%d" % stats.get("level", 1))
	_set_row(dealt_name, dealt_value, "造成伤害", str(stats.get("damage_dealt", 0)))
	var rewards: Dictionary = stats.get("rewards", {})
	var keys: Array = rewards.keys()
	rewards_label.text = "获得奖励："
	rewards_label.add_theme_font_size_override("font_size", 24)
	for child in rewards_grid.get_children():
		child.queue_free()
	if keys.size() > 0:
		rewards_grid.columns = 2 if keys.size() > 1 else 1
		for key in keys:
			var lbl := Label.new()
			lbl.text = "%s ×%d" % [str(key), rewards[key]]
			lbl.add_theme_font_size_override("font_size", 22)
			rewards_grid.add_child(lbl)
		rewards_grid.visible = true
	else:
		rewards_grid.visible = false
	var score: int = stats.get("score", 0)
	score_label.text = "总分：%d" % score
	score_label.add_theme_font_size_override("font_size", 38)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	get_tree().paused = true

func _set_row(name_label: Label, value_label: Label, name_text: String, value_text: String) -> void:
	name_label.text = name_text
	value_label.text = value_text
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
