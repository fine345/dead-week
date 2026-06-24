extends Area2D

var lifetime := 0.1
var life_timer := 0.0

func _ready() -> void:
	add_to_group("boss_laser")
	body_entered.connect(_on_body_entered)
	if has_meta("lifetime"):
		lifetime = float(get_meta("lifetime"))

func _physics_process(delta: float) -> void:
	life_timer += delta
	if life_timer >= lifetime:
		queue_free()
		return
	if has_meta("rotation_speed"):
		rotation += float(get_meta("rotation_speed")) * delta
	for body in get_overlapping_bodies():
		if body == null or not is_instance_valid(body):
			continue
		if body.is_in_group("enemy"):
			continue
		if not body.has_method("take_damage"):
			continue
		body.take_damage(1)

func _on_body_entered(body: Node) -> void:
	if body == null or not body.has_method("take_damage"):
		return
	if body.is_in_group("enemy"):
		return
	body.take_damage(1)
