extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/HBoxContainer/WaveNumber
@onready var current_easy_level: int = Globals.easy_map_current_level

signal next_wave_button_pressed(wave_number: int)

func _ready():
	wave_number_label.text = str(current_easy_level)

func _on_next_wave_button_pressed():
	Globals.easy_map_current_level += 1
	current_easy_level = Globals.easy_map_current_level
	wave_number_label.text = str(Globals.easy_map_current_level)
	next_wave_button_pressed.emit(current_easy_level)
