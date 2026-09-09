class_name Level
extends Node2D

var brick_blueprint := preload("res://bricks/brick.tscn")

var level : Array[String] = [
	"000000000",
	"00000 000",
	"00 000000",
	" 00000000",
	"000000 00",
	"000 00000",
	"000000000",
	"000000000",
	"000000000",
] 

func _ready() -> void:
	var nb_rows := 8
	var nb_cols := 9
	var top_left := Vector2(20, 20)
	# 20px every brick horizontally
	# 10px every brick vertically
	for y in nb_rows:
		for x in nb_cols:
			if level[y][x] == "0":
				var brick : Brick = brick_blueprint.instantiate()
				brick.position = top_left + Vector2(20 * x, 10 * y)
				add_child(brick)
