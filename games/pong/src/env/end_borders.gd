# end_borders.gd
extends Node2D

# Define custom signals that the World script can listen to
signal left_goal_hit(body: Node2D)
signal right_goal_hit(body: Node2D)

func _ready() -> void:
	# Use standard node connection inside its own scene
	$LeftGoal.body_entered.connect(_on_left_goal_entered)
	$RightGoal.body_entered.connect(_on_right_goal_entered)

func _on_left_goal_entered(body: Node2D) -> void:
	left_goal_hit.emit(body) # Forward the event outside

func _on_right_goal_entered(body: Node2D) -> void:
	right_goal_hit.emit(body) # Forward the event outside
