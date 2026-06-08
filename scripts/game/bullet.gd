extends Area2D

@export var move_speed := 300.0
@export var damage := 10
@export var lifetime := 2.0
@export var turn_speed := 10.0

var target: Node2D
var owner_player: Node = null
var current_velocity: Vector2 = Vector2.ZERO
var experience_bonus_multiplier := 1.0
var freeze_chance := 0.0
var burn_chance := 0.0
var bounce_count := 0
var knockback_enabled := false
var hit_count := 0
var has_applied_effects := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = lifetime
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()

func set_target(target_node: Node2D) -> void:
	target = target_node
	if target != null and is_instance_valid(target):
		current_velocity = global_position.direction_to(target.global_position) * move_speed
		if current_velocity == Vector2.ZERO:
			current_velocity = Vector2.RIGHT * move_speed
		rotation = current_velocity.angle()

func set_owner_player(owner_node: Node) -> void:
	owner_player = owner_node

func set_status_modifiers(exp_bonus: float, freeze_prob: float = 0.0, burn_prob: float = 0.0, bounce: int = 0, knockback: bool = false) -> void:
	experience_bonus_multiplier = exp_bonus
	freeze_chance = freeze_prob
	burn_chance = burn_prob
	bounce_count = bounce
	knockback_enabled = knockback

func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		queue_free()
		return
	var desired_direction := global_position.direction_to(target.global_position)
	if desired_direction == Vector2.ZERO:
		desired_direction = current_velocity.normalized() if current_velocity != Vector2.ZERO else Vector2.RIGHT
	var desired_velocity := desired_direction.normalized() * move_speed
	current_velocity = current_velocity.lerp(desired_velocity, clamp(turn_speed * delta, 0.0, 1.0))
	global_position += current_velocity * delta
	rotation = current_velocity.angle()

func _on_body_entered(body: Node) -> void:
	if body == owner_player:
		return
	if body != null and body.has_method("take_damage"):
		if body.has_method("apply_knockback") and knockback_enabled:
			body.apply_knockback(global_position, 180.0)
		if body.has_method("apply_freeze") and freeze_chance > 0.0 and randf() < freeze_chance:
			body.apply_freeze(2.0)
		if body.has_method("apply_burn") and burn_chance > 0.0 and randf() < burn_chance:
			body.apply_burn(5.0, 1)
		body.take_damage(damage)
		has_applied_effects = true
		hit_count += 1
		if hit_count > bounce_count:
			queue_free()
