extends CharacterBody2D

const SPEED = 450.0
@onready var start_position: Vector2 = global_position

func _ready() -> void:
	reset_ball(true)

func _physics_process(delta: float) -> void:
	var col : KinematicCollision2D = move_and_collide(velocity * delta)
	if col:
		var collider = col.get_collider()
		var normal := col.get_normal()
		
		if "Paddle" in collider.name:
			var hit_factor = global_position.y - collider.global_position.y
			var half_paddle_height = 50.0 
			var relative_intersect_y = clamp(hit_factor / half_paddle_height, -0.85, 0.85)
			var bounce_direction_x = 1.0 if normal.x > 0 else -1.0
			
			var new_direction = Vector2(bounce_direction_x, relative_intersect_y).normalized()
			velocity = new_direction * SPEED
		else:
			velocity = velocity.bounce(normal)

# This function must exist for the World script to call it!
func reset_ball(serve_to_player: bool) -> void:
	global_position = start_position
	if serve_to_player:
		velocity = Vector2(-SPEED, 0)
	else:
		velocity = Vector2(SPEED, 0)
