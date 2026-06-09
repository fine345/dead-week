extends Node2D

@export var grid_color: Color = Color(0.15, 0.15, 0.15, 0.45)
@export var grid_spacing: int = 48
@export var line_width: float = 1.0
@export var grid_size: Vector2 = Vector2(2880, 5760)

func _ready() -> void:
	z_index = -100
	scale = Vector2(1, 1)
	queue_redraw()

func _draw() -> void:
	if grid_spacing <= 0:
		return
	var width := int(grid_size.x)
	var height := int(grid_size.y)
	for x in range(0, width + 1, grid_spacing):
		draw_line(Vector2(x, 0), Vector2(x, height), grid_color, line_width)
	for y in range(0, height + 1, grid_spacing):
		draw_line(Vector2(0, y), Vector2(width, y), grid_color, line_width)
