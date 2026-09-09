class_name Level
extends Node2D

signal cleared

var brick_blueprint := preload("res://bricks/brick.tscn")
var bombbrick_blueprint := preload("res://bricks/bomb_brick.tscn")
var hardbrick_blueprint := preload("res://bricks/hard_brick.tscn")

var nb_bricks_left := 0

var level : Array[String] = [
	"0B00BBB00",
	"0000  0B0",
	"0B 00B000",
	" 0B00B0B0",
	"00H0B0 00",
	"0B0 00H00",
	"0B0H0B0B0",
	"0B00B00B0",
] 

func _ready() -> void:
	var nb_rows := 8
	var nb_cols := 9
	var top_left := Vector2(20, 20)
	# 20px every brick horizontally
	# 10px every brick vertically
	for y in nb_rows:
		for x in nb_cols:
			var brick : Brick = null
			if level[y][x] == "0":
				brick = brick_blueprint.instantiate()
			elif level[y][x] == "H":
				brick = hardbrick_blueprint.instantiate()
			elif level[y][x] == "B":
				brick = bombbrick_blueprint.instantiate()
			if brick != null:
				nb_bricks_left += 1
				brick.destroyed.connect(on_brick_destroyed)
				brick.position = top_left + Vector2(20 * x, 10 * y)
				add_child(brick)
				
func on_brick_destroyed() -> void:
	nb_bricks_left -= 1
	if nb_bricks_left == 0:
		cleared.emit()
