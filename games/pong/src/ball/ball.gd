extends CharacterBody2D

const SPEED = 400.0

func _ready() -> void:
	velocity = Vector2(-SPEED, 0)

func _physics_process(delta: float) -> void:
	var col : KinematicCollision2D = move_and_collide(velocity * delta)
	
	if col:
		var collider = col.get_collider()
		
		if "Paddle" in collider.name:
			var hit_factor = global_position.y - collider.global_position.y
			
			var paddle_height = col.get_collider_shape().shape.radius
			
			var relative_intersect_y = hit_factor / paddle_height
			
			var bounce_direction_x = 1.0 if global_position.x > collider.global_position.x else -1.0
			
			var new_direction = Vector2(bounce_direction_x, relative_intersect_y).normalized()
			
			velocity = new_direction * SPEED
			global_position += col.get_normal() * 4.0
		else:
			var normal := col.get_normal()
			velocity = velocity.bounce(normal)
			global_position += normal * 2.0
