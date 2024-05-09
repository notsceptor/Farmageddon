extends CanvasLayer

@onready var main_menu_path: String = "res://Scenes/User_Interface/main_menu_screen.tscn"

signal continue_game_button_pressed

func _on_continue_game_button_pressed():
	continue_game_button_pressed.emit()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	WaveManager.wave_won = false
	visible = false
	TransitionLayer.change_scene(main_menu_path)
