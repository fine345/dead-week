extends Control

var boss: Node2D = null
var max_hp: float = 1000.0
var current_hp: float = 1000.0
var display_hp: float = 1000.0
var bar_width: float = 400.0
var bar_height: float = 12.0

@onready var background: ColorRect = $Background
@onready var lost_bar: ColorRect = $LostHealthBar
@onready var current_bar: ColorRect = $CurrentHealthBar

func _ready() -> void:
	visible = false
	_update_bar_visual()

func _process(delta: float) -> void:
	if boss == null or not is_instance_valid(boss):
		return
	current_hp = float(boss.get("health"))
	if display_hp > current_hp:
		display_hp = lerpf(display_hp, current_hp, delta * 2.0)
		if absf(display_hp - current_hp) < 1.0:
			display_hp = current_hp
	_update_bar_visual()

func show_boss(boss_node: Node2D) -> void:
	boss = boss_node
	max_hp = float(boss.get("max_health"))
	current_hp = max_hp
	display_hp = max_hp
	visible = true
	_update_bar_visual()

func hide_boss() -> void:
	boss = null
	visible = false

func _update_bar_visual() -> void:
	if background != null:
		background.size = Vector2(bar_width, bar_height)
		background.position = Vector2.ZERO
	if lost_bar != null:
		var lost_ratio := display_hp / max_hp if max_hp > 0 else 0.0
		lost_bar.size = Vector2(bar_width * lost_ratio, bar_height)
		lost_bar.position = Vector2.ZERO
		lost_bar.color = Color(0.6, 0.1, 0.1, 0.8)
	if current_bar != null:
		var current_ratio := current_hp / max_hp if max_hp > 0 else 0.0
		current_bar.size = Vector2(bar_width * current_ratio, bar_height)
		current_bar.position = Vector2.ZERO
		current_bar.color = Color(0.8, 0.2, 0.2, 1.0)
