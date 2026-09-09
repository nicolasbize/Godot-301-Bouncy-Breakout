class_name World
extends Node2D

var ball_blueprint := preload("res://ball/ball.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var paddle: Paddle = $Paddle
@onready var score_label: Label = $ScoreLabel
@onready var level: Level = $Level

@export var points_lost_per_ball := 1000

var nb_balls_in_play := 0
var current_score := 0

func _ready() -> void:
	create_new_ball()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _on_ball_detection_area_body_entered(ball: Node2D) -> void:
	ball.queue_free()
	nb_balls_in_play -= 1
	if nb_balls_in_play == 0:
		animation_player.play("lose")
		add_points(-points_lost_per_ball)

func create_new_ball() -> void:
	var new_ball : Ball = ball_blueprint.instantiate()
	new_ball.paddle = paddle
	add_child(new_ball)
	nb_balls_in_play += 1

func _on_level_cleared() -> void:
	destroy_all_balls()
	if level.has_next_level():
		animation_player.play("win")
	else:
		animation_player.play("gameover")

func load_next_level() -> void:
	level.load_next_level()
	create_new_ball()

func destroy_all_balls() -> void:
	for child: Node in get_children():
		if child is Ball:
			child.queue_free()
	nb_balls_in_play = 0

func _on_level_spawn_requested(amount: int, spawn_position: Vector2) -> void:
	for i in amount:
		spawn_ball(spawn_position)

func spawn_ball(spawn_position: Vector2) -> void:
	var new_ball : Ball = ball_blueprint.instantiate()
	new_ball.paddle = paddle
	add_child(new_ball)
	nb_balls_in_play += 1
	new_ball.launch(spawn_position)

func add_points(amount: int) -> void:
	current_score += amount
	if current_score < 0:
		current_score = 0
	score_label.text = "%06d" % current_score

func _on_level_points_scored(amount: int) -> void:
	add_points(amount * nb_balls_in_play)
