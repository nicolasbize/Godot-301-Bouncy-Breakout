class_name World
extends Node2D

var ball_blueprint := preload("res://ball/ball.tscn")

func _on_ball_detection_area_body_entered(ball: Node2D) -> void:
	ball.queue_free()
	$AnimationPlayer.play("lose")

func create_new_ball() -> void:
	var new_ball : Ball = ball_blueprint.instantiate()
	new_ball.paddle = $Paddle
	add_child(new_ball)
