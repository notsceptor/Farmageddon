extends CanvasLayer

signal back_button_pressed()

func _ready():
	print("Settings loaded")

func _on_back_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	back_button_pressed.emit()
