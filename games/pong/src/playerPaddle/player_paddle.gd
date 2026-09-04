extends CharacterBody2D

const SPEED := 400.0
const TEXTURE_UP = preload("res://assets/RedPaddleUp.png")
const TEXTURE_DOWN = preload("res://assets/RedPaddleDown.png")

# Reference the single Sprite2D node using its actual class type
@onready var sprite: Sprite2D = $Sprite2D

func getYDir() -> float:
	return Input.get_action_strength("down") - Input.get_action_strength("up")

func _physics_process(_delta: float) -> void:
	var y_dir := getYDir()
	velocity = Vector2(0, y_dir * SPEED)
	move_and_slide()
	
	# Change the texture of the single sprite based on direction
	if y_dir < 0:
		sprite.texture = TEXTURE_UP
		sprite.offset = Vector2(0, 0)
		 
	elif y_dir > 0:
		sprite.texture = TEXTURE_DOWN
		sprite.offset = Vector2(220, 0) # Adjust these coordinates if it looks off
