extends CanvasLayer

@onready var score_red: Label = $ScoreRed
@onready var score_blue: Label = $ScoreBlue
@onready var end_game_label: Label = $EndGameLabel
@onready var deuce_label: Label = $DeuceLabel     # Reference to our new Deuce Label

func _ready() -> void:
	end_game_label.visible = false
	deuce_label.visible = false

func update_scores(player: int, bot: int) -> void:
	score_blue.text = str(bot)
	score_red.text = str(player)

# Shows or hides the Deuce warning layout text
func set_deuce_visible(is_deuce: bool) -> void:
	deuce_label.visible = is_deuce

func show_game_over(player_won: bool) -> void:
	# Hide the deuce text since the game is officially over
	deuce_label.visible = false
	
	if player_won:
		end_game_label.text = "YOU WIN!!\nPress 'R' to Restart"
		end_game_label.modulate = Color.GREEN
	else:
		end_game_label.text = "GAME OVER\nPress 'R' to Restart"
		end_game_label.modulate = Color.RED
		
	
	end_game_label.visible = true
