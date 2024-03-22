extends CanvasLayer

@onready var waveText = $MarginContainer/HBoxContainer/WaveNumber

signal next_wave_button_pressed()

func _on_next_wave_button_pressed():
	next_wave_button_pressed.emit()
