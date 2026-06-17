extends "res://scripts/game/enemy_base.gd"

func _ready() -> void:
	max_health = 400
	move_speed = 200.0
	experience_drop = 35
	super._ready()

func _apply_visual() -> void:
	_setup_animations(
		"res://assets/sprites/enemies/enemy_4_idle-Sheet.png",
		"res://assets/sprites/enemies/enemy_4_walk-Sheet.png",
		"res://assets/sprites/enemies/enemy_124_hurt-Sheet.png"
	)
