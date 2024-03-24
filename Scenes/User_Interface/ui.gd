extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/HBoxContainer/WaveNumber
@onready var current_easy_level: int = Globals.easy_map_current_level

@onready var next_wave_button: Button = $MarginContainer/HBoxContainer/NextWaveButton

signal next_wave_button_pressed(wave_number: int, wave_size: int)

func _ready():
	next_wave_button.visible = false
	wave_number_label.text = str(current_easy_level)
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true

# DONT NEED TO INCREMENT BY 1 UNTIL THE WAVE HAS BEEN WON -> DO THIS IN THE MAP SECTION ITSELF
func _on_next_wave_button_pressed():
	Globals.easy_map_current_level += 1
	Globals.easy_map_spawn_size += 2
	var next_easy_level: int = Globals.easy_map_current_level
	var next_easy_wave_size: int = Globals.easy_map_spawn_size
	wave_number_label.text = str(Globals.easy_map_current_level)
	next_wave_button_pressed.emit(next_easy_level, next_easy_wave_size)
	next_wave_button.visible = false
