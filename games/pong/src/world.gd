extends Node2D

var player_score: int = 0
var bot_score: int = 0

# Using a safer, dynamic way to find the ball if it moves
@onready var ball = get_node_or_null("Ball")

func _ready() -> void:
	print("--- SYSTEM START: Connecting Goal Signals ---")
	$EndBorders/LeftGoal.body_entered.connect(_on_left_goal_entered)
	$EndBorders/RightGoal.body_entered.connect(_on_right_goal_entered)

func _on_left_goal_entered(body: Node2D) -> void:
	# This print statement will tell us exactly what node touched the goal
	print("Something touched Left Goal: ", body.name)
	
	# Fallback check: if it is a CharacterBody2D, treat it as the ball
	if body is CharacterBody2D:
		bot_score += 1
		print("Bot Scored! Score: ", bot_score)
		body.call("reset_ball", false)

func _on_right_goal_entered(body: Node2D) -> void:
	print("Something touched Right Goal: ", body.name)
	
	if body is CharacterBody2D:
		player_score += 1
		print("Player Scored! Score: ", player_score)
		body.call("reset_ball", true)
