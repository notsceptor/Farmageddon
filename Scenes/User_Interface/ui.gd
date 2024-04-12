extends CanvasLayer

#wave number info
@onready var wave_number_label: Label = $MarginContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer2/TestRefreshMapButton

#currency system implementation
@onready var gold_label: Label = $ResourcesContainer/GoldLabel
@onready var scrap_metal_label: Label = $ResourcesContainer/ScrapMetalLabel
@onready var gems_label: Label = $ResourcesContainer/GemsLabel

#debugs scene implementation
@export var debug_enemy: PackedScene




signal next_wave_button_pressed
signal refresh_map_button_pressed
signal place_turret(turret_scene, location)

func _ready():
	next_wave_button.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	update_UI()

func update_UI():
	gold_label.text = str(Globals.gold)
	scrap_metal_label.text = str(Globals.scrap_metal)
	gems_label.text = str(Globals.gems)
	
func _on_next_wave_button_pressed():
	update_UI()
	next_wave_button_pressed.emit()
	
func _on_test_refresh_map_button_pressed():
	refresh_map_button_pressed.emit()

func _on_activity_button_place_turret(turret_scene, location):
	place_turret.emit(turret_scene, location)

func _on_debug_enemy_button_pressed():
	var enemy = debug_enemy.instantiate()
	add_child(enemy)
	
