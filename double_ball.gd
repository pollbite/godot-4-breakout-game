extends CharacterBody2D

@export var speed: float = 200.0
@export var max_speed: float = 1000.0
@export var start_text: RichTextLabel 

var forward = Vector2(1.0, 1.0)
const PADDLE_WIDTH: float = 100.0
var is_running: bool = false

func _ready() -> void:
	forward = Vector2(1,1).normalized()

func _physics_process(delta: float) -> void:
	print(forward)
	var collision: KinematicCollision2D = move_and_collide(forward * speed * delta)
	if (collision):
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + 0.5, 1, max_speed)
		
		if (collision.get_collider().is_in_group("Bricks")):
			collision.get_collider().queue_free()
			Global.current_score += 10
		
		# Paddle bounce should be based on ball position
		if (collision.get_collider().is_in_group("Paddle")):
			var paddle_x = collision.get_collider().position.x - PADDLE_WIDTH / 2
			var pos_on_paddle = (position.x - paddle_x) / PADDLE_WIDTH
			#print("Hit the paddle!" + str(pos_on_paddle))
			var bounce_angle = lerp(-PI * 0.8, -PI * 0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			

func _ScreenShake(): 
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	tween.tween_property(camera, "offset", Vector2(5, 5), 0.1)
	tween.tween_property(camera, "offset", Vector2(-5, -5), 0.1)
	tween.tween_property(camera, "offset", Vector2(0, 0), 0.1)

func _on_timer_timeout():
	self.queue_free()
