extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer2/TestRefreshMapButton
@onready var upcoming_enemies_label: Label = $MarginContainer/VBoxContainer/UpcomingEnemies

@export var debug_enemy: PackedScene

signal next_wave_button_pressed
signal refresh_map_button_pressed
signal place_turret(turret_scene, location)

func _ready():
	next_wave_button.visible = false
	upcoming_enemies_label.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	upcoming_enemies_label.visible = true
	get_upcoming_enemies()

func _on_next_wave_button_pressed():
	next_wave_button_pressed.emit()
	
func _on_test_refresh_map_button_pressed():
	refresh_map_button_pressed.emit()

func _on_activity_button_place_turret(turret_scene, location):
	place_turret.emit(turret_scene, location)

func _on_debug_enemy_button_pressed():
	var enemy = debug_enemy.instantiate()
	add_child(enemy)

func _on_map_parent_node_wave_ended():
	get_upcoming_enemies()
	upcoming_enemies_label.visible = true

func get_upcoming_enemies():
	var upcoming_text = "Upcoming:\n"
	for enemy_name in WaveManager.debug_enemy_dictionary.keys():
		var qty_str = str(WaveManager.debug_enemy_dictionary[enemy_name])
		upcoming_text += qty_str + " " + enemy_name + "\n"
	upcoming_enemies_label.text = upcoming_text
