extends CharacterBody2D

# Multi-level AI settings
@export var difficulty: int = 3 # 1: Easy, 2: Medium, 3: Hard
@export var ball_path: NodePath

@onready var ball: Node2D = get_node_or_null(ball_path)

# Texture configuration
const TEXTURE_UP = preload("res://assets/BluePaddleUp.png")
const TEXTURE_DOWN = preload("res://assets/BluePaddleDown.png")

# Dynamic AI variables based on difficulty
var speed: float = 300.0
var error_margin: float = 0.0
var reaction_cooldown: float = 0.0
var reaction_timer: float = 0.0
var target_y: float = 0.0

func _ready() -> void:
	setup_difficulty()
	target_y = global_position.y

func setup_difficulty() -> void:
	match difficulty:
		1: # Easy: Slow, highly inaccurate, updates targets slowly
			speed = 220.0
			error_margin = 90.0
			reaction_cooldown = 0.25
		2: # Medium: Base speed, moderate accuracy, faster updates
			speed = 300.0
			error_margin = 40.0
			reaction_cooldown = 0.1
		3: # Hard: Fast, perfect tracking, instantaneous reaction
			speed = 450.0
			error_margin = 0.0
			reaction_cooldown = 0.0

func getYDir(delta: float) -> float:
	if not ball:
		return 0.0

	# Handle reaction delay for lower difficulties
	if reaction_cooldown > 0.0:
		reaction_timer += delta
		if reaction_timer >= reaction_cooldown:
			update_target()
			reaction_timer = 0.0
	else:
		update_target()

	# Determine direction based on target position
	# Using a small deadzone (5 pixels) to prevent paddle jittering
	if global_position.y < target_y - 5.0:
		return 1.0  # Move down
	elif global_position.y > target_y + 5.0:
		return -1.0 # Move up
		
	return 0.0

func update_target() -> void:
	# Add a random offset to simulate human error based on difficulty
	var random_offset = randf_range(-error_margin, error_margin)
	target_y = ball.global_position.y + random_offset

func _physics_process(delta: float) -> void:
	var y_dir := getYDir(delta)
	velocity = Vector2(0, y_dir * speed)
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			# Best practice: Add your ball node to a group named "ball" in the editor
			if collision.get_collider().is_in_group("ball"):
				velocity = Vector2.ZERO
				break 
				
	if y_dir < 0:
		_switch_to_up_state()
	elif y_dir > 0:
		_switch_to_down_state()


func _switch_to_up_state() -> void:
	$Sprite2D.texture = TEXTURE_UP
	$CollisionUp.set_deferred("disabled", false)
	$CollisionDown.set_deferred("disabled", true)

func _switch_to_down_state() -> void:
	$Sprite2D.texture = TEXTURE_DOWN
	$CollisionDown.set_deferred("disabled", false)
	$CollisionUp.set_deferred("disabled", true)
