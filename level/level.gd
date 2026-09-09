class_name Level
extends Node2D

signal cleared
signal points_scored(amount: int)
signal spawn_requested(amount: int, spawn_position: Vector2)

var brick_blueprint := preload("res://bricks/brick.tscn")
var bombbrick_blueprint := preload("res://bricks/bomb_brick.tscn")
var hardbrick_blueprint := preload("res://bricks/hard_brick.tscn")
var spawnbrick_blueprint := preload("res://bricks/spawn_brick.tscn")

var nb_bricks_left := 0

var level : Array[String] = [
	"0B0000000",
	"0000  000",
	"0B 00B000",
	" 0B000+00",
	"00H000 00", 
	"000 00H00",
	"000H0B000",
	"0+00B00B0",
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
			elif level[y][x] == "+":
				brick = spawnbrick_blueprint.instantiate()
			if brick != null:
				nb_bricks_left += 1
				brick.destroyed.connect(on_brick_destroyed)
				brick.position = top_left + Vector2(20 * x, 10 * y)
				add_child(brick)
				
func on_brick_destroyed(brick: Brick) -> void:
	nb_bricks_left -= 1
	points_scored.emit(brick.points)
	if brick.balls_spawned > 0:
		spawn_requested.emit(brick.balls_spawned, brick.position)
	if nb_bricks_left == 0:
		cleared.emit()
