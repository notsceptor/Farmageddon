extends CanvasLayer

@onready var main_menu_path: String = "res://Scenes/User_Interface/main_menu_screen.tscn"

signal continue_game_button_pressed
signal settings_button_pressed

func _on_continue_game_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	continue_game_button_pressed.emit()

func _on_main_menu_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	get_tree().paused = false
	WaveManager.wave_won = false
	visible = false
	TransitionLayer.change_scene(main_menu_path)
	GlobalAudioPlayer.stop_idle_music()
	GlobalAudioPlayer.stop_battle_music()

func _on_settings_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	settings_button_pressed.emit()
