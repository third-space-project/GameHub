extends CharacterBody2D

# --- 1. CONFIGURATION ---
const SPEED := 300.0

# Preloading textures prevents lag spikes when swapping sprites mid-game
const TEXTURE_UP = preload("res://assets/RedPaddleUp.png")     # <-- Change to your actual file path
const TEXTURE_DOWN = preload("res://assets/RedPaddleDown.png") # <-- Change to your actual file path

# --- 2. INPUT PROCESSING ---
func getYDir() -> float:
	# Returns 1.0 for down, -1.0 for up, and 0.0 if neither or both are pressed
	return Input.get_action_strength("down") - Input.get_action_strength("up")

# --- 3. PHYSICS & STATE LOOP ---
func _physics_process(_delta: float) -> void:
	# Handle vertical movement physics
	var y_dir := getYDir()
	velocity = Vector2(0, y_dir * SPEED)
	move_and_slide()
	
	# Handle sprite and collision switching based on actual movement intent
	if y_dir < 0:
		_switch_to_up_state()
	elif y_dir > 0:
		_switch_to_down_state()

# --- 4. STATE SWITCHING METHODS ---
# Using set_deferred is mandatory when changing collision states during physics processing

func _switch_to_up_state() -> void:
	$Sprite2D.texture = TEXTURE_UP
	$CollisionUp.set_deferred("disabled", false)   # Turn ON Up Collision
	$CollisionDown.set_deferred("disabled", true)  # Turn OFF Down Collision

func _switch_to_down_state() -> void:
	$Sprite2D.texture = TEXTURE_DOWN
	$CollisionDown.set_deferred("disabled", false) # Turn ON Down Collision
	$CollisionUp.set_deferred("disabled", true)   # Turn OFF Up Collision
