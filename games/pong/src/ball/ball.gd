extends CharacterBody2D

const SPEED = 400.0

func _ready() -> void:
	velocity = Vector2(-SPEED, 0)

func _physics_process(delta: float) -> void:
	var col : KinematicCollision2D = move_and_collide(velocity * delta)
	
	if col:
		var collider = col.get_collider()
		
		# check if we hit the paddle by looking at its name (case-sensitive!)
		if "Paddle" in collider.name:
			# 1. Get the vertical distance between the ball center and paddle center
			var hit_factor = global_position.y - collider.global_position.y
			
			# 2. Get the height of the paddle to normalize the hit
			# (Assumes your paddle collider radius is roughly 32-64 pixels)
			var paddle_height = col.get_collider_shape().shape.radius
			
			# 3. Calculate a percentage (-1.0 at very top, 0.0 at center, 1.0 at bottom)
			var relative_intersect_y = hit_factor / paddle_height
			
			# 4. Determine bounce direction (If ball is on the left, bounce right, else left)
			var bounce_direction_x = 1.0 if global_position.x > collider.global_position.x else -1.0
			
			# 5. Create a clean new direction vector (Steeper angle if hit near edges)
			var new_direction = Vector2(bounce_direction_x, relative_intersect_y).normalized()
			
			# 6. Apply the fresh velocity and push the ball away to break contact
			velocity = new_direction * SPEED
			global_position += col.get_normal() * 4.0
		else:
			# Normal flat wall bounce behavior for walls, bricks, ceilings, etc.
			var normal := col.get_normal()
			velocity = velocity.bounce(normal)
			global_position += normal * 2.0
