extends Control

signal reward_selected(reward_id: String)

@onready var option1: Button = $Panel/VBox/Option1
@onready var option2: Button = $Panel/VBox/Option2
@onready var option3: Button = $Panel/VBox/Option3

func _ready() -> void:
	option1.pressed.connect(func(): _emit_reward("move_speed"))
	option2.pressed.connect(func(): _emit_reward("attack_speed"))
	option3.pressed.connect(func(): _emit_reward("pickup_range"))

func _emit_reward(reward_id: String) -> void:
	reward_selected.emit(reward_id)
