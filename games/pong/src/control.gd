extends Control

@onready var menu_button: MenuButton = $MenuButton

# 1. This runs as soon as the menu opens
func _ready() -> void:
	var popup: PopupMenu = menu_button.get_popup()
	popup.id_pressed.connect(_on_menu_item_pressed)
	popup.add_theme_font_size_override("font_size", 24)
# 2. This runs whenever you pick a dropdown item
func _on_menu_item_pressed(id: int) -> void:
	match id:
		0:
			GameManager.difficulty = 1
		1:
			GameManager.difficulty = 2
		2:
			GameManager.difficulty = 3
			
	print("Global variable updated to: ", GameManager.difficulty)

# 3. This changes the scene when you click the main button
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/world.tscn")
