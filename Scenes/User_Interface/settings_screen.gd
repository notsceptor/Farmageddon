extends CanvasLayer

signal back_button_pressed()

@onready var music_volume_text: Label = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/MusicVolValue

func _on_back_button_pressed():
	print("BACK")
	back_button_pressed.emit()
