extends Node

const SETTINGS_PATH := "user://settings.json"
var joystick_mode := "anywhere"
var previous_scene := "res://scenes/ui/main_menu.tscn"

func _ready() -> void:
	_load()

func _load() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK:
		return
	var data: Dictionary = json.data
	if data.has("joystick_mode"):
		joystick_mode = data["joystick_mode"]

func _save() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({"joystick_mode": joystick_mode}, "\t"))
	file.close()

func set_joystick_mode(mode: String) -> void:
	joystick_mode = mode
	_save()

func is_fixed_joystick() -> bool:
	return joystick_mode == "fixed"
