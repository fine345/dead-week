extends Node2D

var _sprite: AnimatedSprite2D
var _player: Node2D = null
var _base_offset := Vector2.ZERO
var _drift := Vector2.ZERO
var _drift_speed := 0.0
var _drift_angle := 0.0
var _state := "following"
var _fire_pos := Vector2.ZERO

const FOLLOW_RANGE := 40.0
const RETURN_SPEED := 400.0
const DRIFT_RADIUS := 8.0
const DRIFT_SPEED_MIN := 0.8
const DRIFT_SPEED_MAX := 2.0
const DRIFT_CHANGE_INTERVAL := 1.5

var _drift_timer := 0.0

func _ready() -> void:
	_sprite = $AnimatedSprite2D
	_sprite.scale = Vector2(2.0, 2.0)
	var sf := SpriteFrames.new()
	sf.add_animation("idle")
	sf.set_animation_loop("idle", true)
	sf.set_animation_speed("idle", 5.0)
	var tex = load("res://assets/sprites/calculator-Sheet.png")
	sf.add_frame("idle", tex)
	_sprite.sprite_frames = sf
	_sprite.play("idle")
	_pick_random_offset()
	_pick_new_drift()

func setup(player: Node2D) -> void:
	_player = player
	global_position = _player.global_position + _base_offset

func _pick_random_offset() -> void:
	var angle := randf() * TAU
	var dist := randf_range(20.0, FOLLOW_RANGE)
	_base_offset = Vector2(cos(angle), sin(angle)) * dist
	_base_offset.y = minf(_base_offset.y, -10.0)

func _pick_new_drift() -> void:
	_drift_angle = randf() * TAU
	_drift_speed = randf_range(DRIFT_SPEED_MIN, DRIFT_SPEED_MAX)
	_drift_timer = DRIFT_CHANGE_INTERVAL

func _process(delta: float) -> void:
	if _player == null or not is_instance_valid(_player):
		return
	match _state:
		"following":
			_process_following(delta)
		"firing":
			pass
		"returning":
			_process_returning(delta)

func _process_following(delta: float) -> void:
	_drift_timer -= delta
	if _drift_timer <= 0.0:
		_pick_new_drift()
	_drift_angle += _drift_speed * delta
	_drift = Vector2(cos(_drift_angle), sin(_drift_angle)) * DRIFT_RADIUS
	var target_pos: Vector2 = _player.global_position + _base_offset + _drift
	global_position = global_position.move_toward(target_pos, RETURN_SPEED * delta)

func _process_returning(delta: float) -> void:
	_drift = Vector2.ZERO
	var target_pos: Vector2 = _player.global_position + _base_offset
	var dist: float = global_position.distance_to(target_pos)
	if dist > 1.0:
		global_position = global_position.move_toward(target_pos, RETURN_SPEED * delta)
	else:
		global_position = target_pos
		_state = "following"
		_pick_random_offset()
		_pick_new_drift()

func start_fire() -> void:
	_state = "firing"
	_fire_pos = global_position
	_drift = Vector2.ZERO

func end_fire() -> void:
	_state = "returning"

func get_fire_position() -> Vector2:
	return _fire_pos
