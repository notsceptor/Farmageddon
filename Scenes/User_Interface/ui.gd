extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer2/TestRefreshMapButton

signal next_wave_button_pressed
signal refresh_map_button_pressed

func _ready():
	next_wave_button.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true

func _on_next_wave_button_pressed():
	next_wave_button_pressed.emit()
	
func _on_test_refresh_map_button_pressed():
	refresh_map_button_pressed.emit()
