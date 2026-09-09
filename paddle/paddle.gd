class_name Paddle
extends AnimatableBody2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta):
	position.x = clamp(get_global_mouse_position().x, 17, 183)

func bounce() -> void:
	audio_stream_player.play()
	create_tween() \
		.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.5) \
		.from(Vector2(1.6, 0.6)) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
