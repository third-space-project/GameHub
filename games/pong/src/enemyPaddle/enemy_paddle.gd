extends CharacterBody2D

const POS = Vector2(893, 451)

@export var ball_path: NodePath
@export var difficulty: int = 1 
@onready var ball: Node2D = get_node_or_null(ball_path)
@onready var sprite: Sprite2D = $Sprite2D

const TEXTURE_UP = preload("res://assets/BluePaddleUp.png")
const TEXTURE_DOWN = preload("res://assets/BluePaddleDown.png")

var speed: float = 0.0
var error_margin: float = 0.0
var reaction_cooldown: float = 0.0
var reaction_timer: float = 0.0
var target_y: float = 0.0

var is_locked: bool = false
var lock_timer: float = 0.0
const LOCK_DURATION: float = 1.5 # Adjusted for balanced gameplay
var has_moved_this_turn: bool = false

func _ready() -> void:
	global_position = POS 
	difficulty = GameManager.difficulty
	print("Enemy spawned with difficulty level: ", difficulty) 
	setup_difficulty()
	target_y = global_position.y
	
	
func setup_difficulty() -> void:
	match difficulty:
		1:
			speed = 280.0
			error_margin = 60.0
			reaction_cooldown = 0.25
		2:
			speed = 430.0
			error_margin = 15.0
			reaction_cooldown = 0.2
			
		3:
			speed = 320.0
			error_margin = 8.0
			reaction_cooldown = 0.1
			

func getYDir(delta: float) -> float:
	if not ball:
		return 0.0

	var half_table_x = get_viewport_rect().size.x / 2.0
	if ball.global_position.x < half_table_x:
		has_moved_this_turn = false
		return 0.0

	if reaction_cooldown > 0.0:
		reaction_timer += delta
		if reaction_timer >= reaction_cooldown:
			update_target()
			reaction_timer = 0.0
	else:
		update_target()

	# 15px Deadzone stops micro-movement lockout glitches
	if global_position.y < target_y - 15.0:
		return 1.0  
	elif global_position.y > target_y + 15.0:
		return -1.0 
		
	return 0.0

func update_target() -> void:
	var random_offset = randf_range(-error_margin, error_margin)
	target_y = ball.global_position.y + random_offset

func _physics_process(delta: float) -> void:
	if is_locked:
		lock_timer -= delta
		if lock_timer <= 0.0:
			is_locked = false
		velocity = Vector2.ZERO
	else:
		var y_dir = getYDir(delta)
		if y_dir != 0.0:
			has_moved_this_turn = true
			velocity = Vector2(0, y_dir * speed)
		else:
			velocity = Vector2.ZERO

	move_and_slide()
	global_position.x = POS.x 

	# Handle instant lockout state safely upon striking the ball
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider and (collider.is_in_group("ball") or collider.name == "ball"):
				trigger_lockout()
				break

	if velocity.y < 0:
		sprite.texture = TEXTURE_UP
		sprite.flip_v = true
		sprite.offset = Vector2(-10, 200)

	elif velocity.y > 0:
		
		sprite.flip_v = false
		sprite.offset = Vector2(0, 0)


func trigger_lockout() -> void:
	is_locked = true
	lock_timer = LOCK_DURATION
	has_moved_this_turn = false
	velocity = Vector2.ZERO
