class_name Ball
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var paddle : Paddle
@export var speed := 120.0 # pixels per sec
@export var min_angle := 0.4

enum State {Docked, Flying}

var current_state := State.Docked

func _ready() -> void:
	var direction := Vector2(randf_range(-1, 1), -1).normalized()
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if current_state == State.Docked:
		position = paddle.position + Vector2(0, -8)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			current_state = State.Flying
	else:
		fly(delta)

func launch(spawn_position: Vector2) -> void:
	position = spawn_position
	current_state = State.Flying

func fly(delta: float) -> void:
	var collision := move_and_collide(velocity * delta)
	if collision != null:
		var old_sign_vx : int = sign(velocity.x)
		var collider := collision.get_collider()
		if collider is Paddle:
			velocity = get_velocity_from_paddle(paddle)
			paddle.bounce()
		else:
			if collider is Brick:
				var brick : Brick = collider
				brick.take_damage()
			else:
				audio_stream_player.play()
			velocity = velocity.bounce(collision.get_normal())
			fix_shallow_angle()
		if old_sign_vx == sign(velocity.x):
			squish_horizontal()
		else:
			squish_vertical()

func get_velocity_from_paddle(paddle: Paddle) -> Vector2:
	var paddle_half_width := 16
	var offset := (position.x - paddle.position.x) / paddle_half_width
	offset = clamp(offset, -1, 1)
	return Vector2(offset, -1).normalized() * speed

func fix_shallow_angle() -> void:
	var direction := velocity.normalized()
	if direction.y > 0 and direction.y < min_angle:
		direction.y = min_angle
	elif direction.y < 0 and direction.y > -min_angle:
		direction.y = -min_angle
	velocity = direction * speed

func squish_horizontal() -> void:
	create_tween() \
		.tween_property(sprite_2d, "scale", Vector2(1, 1), 1.0) \
		.from(Vector2(1.7, 0.8)) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
		
func squish_vertical() -> void:
	create_tween() \
		.tween_property(sprite_2d, "scale", Vector2(1, 1), 1.0) \
		.from(Vector2(0.8, 1.7)) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
