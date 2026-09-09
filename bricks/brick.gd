class_name Brick
extends StaticBody2D

signal destroyed(brick: Brick)

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var brick_sprite: Sprite2D = $BrickSprite
@onready var explosion_area: Area2D = $ExplosionArea
@onready var flash_sprite: Sprite2D = $FlashSprite

@export var balls_spawned := 0
@export var points := 10

var health := 0
var is_dying := false

func _ready() -> void:
	health = brick_sprite.vframes

func take_damage() -> void:
	if not is_dying:
		health -= 1
		squash()
		audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
		audio_stream_player.play()
		var flash_tween := create_tween()
		flash_tween.tween_property(flash_sprite, "modulate:a", 1.0, 0.05)
		flash_tween.tween_property(flash_sprite, "modulate:a", 0.0, 0.2)
		
		if health > 0:
			brick_sprite.frame += 1
		else:
			is_dying = true
			destroyed.emit(self)
			flash_tween.tween_callback(queue_free)
			explode_neighbors()

func squash() -> void:
	create_tween() \
		.tween_property(brick_sprite, "scale", Vector2(1, 1), 1.0) \
		.from(Vector2(1.6, 0.6)) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)

func explode_neighbors() -> void:
	var neighbors : Array[Node2D] = explosion_area.get_overlapping_bodies()
	for neighbor : Node2D in neighbors:
		if neighbor is Brick and neighbor != self:
			var brick : Brick = neighbor
			brick.take_damage()
	
	
	
	
