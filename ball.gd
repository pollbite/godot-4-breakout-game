extends CharacterBody2D

@onready var double_ball = preload("res://double_ball.tscn")

@export var speed: float = 200.0
@export var max_speed: float = 1000.0
@export var start_text: RichTextLabel 

var forward = Vector2(1,1).normalized()
const PADDLE_WIDTH: float = 100.0
var is_running: bool = false

@onready var camera = get_viewport().get_camera_2d()

func _physics_process(_delta: float) -> void:
	if (not is_running):
		if (Input.is_action_just_pressed("click_window")):
			is_running = true
			start_text.visible = false
			visible = true

		return
	
	var collision: KinematicCollision2D = move_and_collide(forward * speed * _delta)
	if (collision):
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + 0.5, 1, max_speed)
		
		if (collision.get_collider().is_in_group("Bricks")):
			_ScreenShake()
			collision.get_collider().queue_free()
			Global.current_score += 10
			
		if (collision.get_collider().is_in_group("DoubleBallPowerUp")):
			spawn_duplicate_ball(global_position + Vector2(10, 10), Vector2(1,1))
		
		# Paddle bounce should be based on ball position
		if (collision.get_collider().is_in_group("Paddle")):
			var paddle_x = collision.get_collider().position.x - PADDLE_WIDTH / 2
			var pos_on_paddle = (position.x - paddle_x) / PADDLE_WIDTH
			#print("Hit the paddle!" + str(pos_on_paddle))
			var bounce_angle = lerp(-PI * 0.8, -PI * 0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			
		#Handle game over conditions
		if (collision.get_collider().is_in_group("GameOver")):
			is_running = false
			start_text.visible = true
			start_text.text = "GAME OVER"

func spawn_duplicate_ball(location: Vector2, direction:Vector2):
	var duplicate = double_ball.instantiate()
	duplicate.forward = direction.normalized
	duplicate.position = location
	get_parent().add_child(duplicate)

func _ScreenShake(): 
	var tween = create_tween()
	tween.tween_property(camera, "offset", Vector2(5, 5), 0.1)
	tween.tween_property(camera, "offset", Vector2(-5, -5), 0.1)
	tween.tween_property(camera, "offset", Vector2(0, 0), 0.1)
