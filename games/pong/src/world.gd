extends Node2D

var player_score: int = 0
var bot_score: int = 0
var game_active: bool = true 

@onready var scoreboard = $Scoreboard
@onready var ball = get_node_or_null("ball")

func _ready() -> void:
	print("--- SYSTEM START: Connecting Goal Signals ---")
	$EndBorders/LeftGoal.body_entered.connect(_on_left_goal_entered)
	$EndBorders/RightGoal.body_entered.connect(_on_right_goal_entered)
	
	_update_score_display()

# Listen for the R Key input to restart
func _input(event: InputEvent) -> void:
	if not game_active and event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and event.keycode == KEY_R):
		get_tree().reload_current_scene() # Instantly reloads the entire world level

func _on_left_goal_entered(body: Node2D) -> void:
	if not game_active: return 
	
	if body is CharacterBody2D:
		bot_score += 1
		print("Bot Scored! Score: ", bot_score)
		_update_score_display()
		_check_match_state(false, body)

func _on_right_goal_entered(body: Node2D) -> void:
	if not game_active: return 
	
	if body is CharacterBody2D:
		player_score += 1
		print("Player Scored! Score: ", player_score)
		_update_score_display()
		_check_match_state(true, body)

func _update_score_display() -> void:
	if scoreboard and scoreboard.has_method("update_scores"):
		scoreboard.update_scores(player_score, bot_score)

# Consolidates checking for a Win, a Deuce, or a normal ball reset
func _check_match_state(is_player_scoring: bool, ball_node: Node2D) -> void:
	# 1. Check Ping Pong Win Condition (At least 11 points, up by 2)
	if player_score >= 11 and (player_score - bot_score) >= 2:
		_end_match(true)
		return
	elif bot_score >= 11 and (bot_score - player_score) >= 2:
		_end_match(false)
		return
		
	# 2. Check Ping Pong Deuce Condition (At least 10-10 or tied past 10)
	if player_score >= 10 and bot_score >= 10:
		if scoreboard and scoreboard.has_method("set_deuce_visible"):
			scoreboard.set_deuce_visible(true)
	else:
		if scoreboard and scoreboard.has_method("set_deuce_visible"):
			scoreboard.set_deuce_visible(false)
			
	# 3. If no one won yet, reset ball placement to keep playing
	ball_node.call("reset_ball", is_player_scoring)

func _end_match(player_won: bool) -> void:
	game_active = false
	print("Match Over! Player Won: ", player_won)
	
	if scoreboard and scoreboard.has_method("show_game_over"):
		scoreboard.show_game_over(player_won)
	
	if ball:
		ball.queue_free() 
