extends Node2D

const BG_TEXTURE := preload("res://assets/sprites/background_simple_block-Sheet.png")
const SRC_SIZE := Vector2(320, 160)
const DRAW_SCALE := 2.0
const TILE_W := 640.0
const TILE_H := 320.0
const ROW_OFFSET := 320.0
const VIEWPORT_SIZE := Vector2(720, 1440)
const MAP_EXTEND := 2000.0

func _ready() -> void:
	z_index = -100
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var cam := get_viewport().get_camera_2d()
	var center := Vector2(360, 720) if cam == null else cam.global_position
	var half := VIEWPORT_SIZE * 0.5 + Vector2(MAP_EXTEND, MAP_EXTEND)
	var left := center.x - half.x
	var right := center.x + half.x
	var top := center.y - half.y
	var bottom := center.y + half.y
	var start_row := int(floor(top / TILE_H)) - 1
	var end_row := int(ceil(bottom / TILE_H)) + 1
	var start_col := int(floor(left / TILE_W)) - 2
	var end_col := int(ceil(right / TILE_W)) + 2
	for row in range(start_row, end_row + 1):
		var y := row * TILE_H
		var x_off := ROW_OFFSET if row % 2 == 0 else 0.0
		for col in range(start_col, end_col + 1):
			var x := col * TILE_W + x_off
			draw_set_transform(Vector2(x, y), 0.0, Vector2(DRAW_SCALE, DRAW_SCALE))
			draw_texture(BG_TEXTURE, Vector2.ZERO)
	draw_set_transform(Vector2.ZERO)
