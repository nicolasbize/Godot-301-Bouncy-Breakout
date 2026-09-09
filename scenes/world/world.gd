class_name World
extends Node2D

var ball_blueprint := preload("res://ball/ball.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var paddle: Paddle = $Paddle

func _on_ball_detection_area_body_entered(ball: Node2D) -> void:
	ball.queue_free()
	animation_player.play("lose")

func create_new_ball() -> void:
	var new_ball : Ball = ball_blueprint.instantiate()
	new_ball.paddle = paddle
	add_child(new_ball)

func _on_level_cleared() -> void:
	animation_player.play("win")
