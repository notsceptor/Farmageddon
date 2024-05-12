extends CanvasLayer

signal back_button_pressed()

@onready var music_volume_text: Label = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/MusicVolValue

func _on_back_button_pressed():
	print("BACK")
	back_button_pressed.emit()

func _on_music_vol_slider_value_changed(value):
	music_volume_text.text = str(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
