extends CanvasLayer

#wave number info
@onready var wave_number_label: Label = $MarginContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer/HBoxContainer/TestRefreshMapButton

#currency system implementation
@onready var gold_label: Label = $ResourcesContainer/GoldLabel
@onready var scrap_metal_label: Label = $ResourcesContainer/ScrapMetalLabel
@onready var gems_label: Label = $ResourcesContainer/GemsLabel

#currency progress bars
@onready var gold_progress_bar: ProgressBar = $ResourcesContainer/GoldProgress
@onready var scrap_metal_progress_bar: ProgressBar = $ResourcesContainer/ScrapProgress
@onready var gems_progress_bar: ProgressBar = $ResourcesContainer/GemsProgress

#debugs scene implementation
@export var debug_enemy: PackedScene

#hotbar implementation
@onready var hotbar_container: HBoxContainer = $HBoxContainer

signal next_wave_button_pressed
signal refresh_map_button_pressed

func _ready():
	next_wave_button.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	CurrencyManager.ui_node = self
	
	update_UI()
	
	for i in range(6):
		var activity_button = preload("res://Scenes/User_Interface/activity_button.tscn").instantiate()
		activity_button.enable_drag_and_drop = true
		hotbar_container.add_child(activity_button)
		
	hotbar_container.populate_hotbar()

func update_UI():
	gold_label.text = str(Globals.gold)
	scrap_metal_label.text = str(Globals.scrap_metal)
	gems_label.text = str(Globals.gems)
	update_progress_bars()
		
func _on_ItemSlot_gui_input(event, index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pass
	
func update_progress_bars():
	gold_progress_bar.max_value = 1000
	gold_progress_bar.value = Globals.gold
	
	scrap_metal_progress_bar.max_value = 1000
	scrap_metal_progress_bar.value = Globals.scrap_metal
	
	gems_progress_bar.max_value = 1000
	gems_progress_bar.value = Globals.gems
	
func _on_next_wave_button_pressed():
	update_UI()
	next_wave_button_pressed.emit()
	
func _on_test_refresh_map_button_pressed():
	refresh_map_button_pressed.emit()

func _on_debug_enemy_button_pressed():
	var enemy = debug_enemy.instantiate()
	add_child(enemy)
