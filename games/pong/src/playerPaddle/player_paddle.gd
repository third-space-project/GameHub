extends CharacterBody2D

const SPEED := 300.0
const TEXTURE_UP = preload("res://assets/RedPaddleUp.png")
const TEXTURE_DOWN = preload("res://assets/RedPaddleDown.png")

func getYDir() -> float:
	return Input.get_action_strength("down") - Input.get_action_strength("up")

func _physics_process(_delta: float) -> void:
	var y_dir := getYDir()
	
	velocity = Vector2(0, y_dir * SPEED)
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.get_collider().name == "ball":
				velocity = Vector2.ZERO
				return
	
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
