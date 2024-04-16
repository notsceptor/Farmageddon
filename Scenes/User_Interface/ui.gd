extends CanvasLayer

#wave number info
@onready var wave_number_label: Label = $MarginContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer2/TestRefreshMapButton

#inventory management
@onready var hotbar = $Hotbar
@onready var inventory_menu = $InventoryMenu
@onready var drag_preview = $DragPreview

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

signal next_wave_button_pressed
signal refresh_map_button_pressed
signal place_turret(turret_scene, location)

func _ready():
	for item_slot in get_tree().get_nodes_in_group("item_slot"):
		var index = item_slot.get_index()
		item_slot.connect("gui_input", Callable(self, "_on_ItemSlot_gui_input").bind(index))
		
	next_wave_button.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	CurrencyManager.ui_node = self
	
	update_UI()

func update_UI():
	gold_label.text = str(Globals.gold)
	scrap_metal_label.text = str(Globals.scrap_metal)
	gems_label.text = str(Globals.gems)
	update_progress_bars()

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu"):
		if inventory_menu.visible and drag_preview.dragged_item: return
		hotbar.visible = !hotbar.visible
		inventory_menu.visible = !inventory_menu.visible
		
func _on_ItemSlot_gui_input(event, index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if inventory_menu.visible:
				drag_item(index)
				
func drag_item(index):
	var inventory_item = Inventory.items[index]
	var dragged_item = drag_preview.dragged_item
	if inventory_item and !dragged_item:
		drag_preview.dragged_item = Inventory.remove_item(index)
		print("pick item")
	elif !inventory_item and dragged_item:
		drag_preview.dragged_item = Inventory.set_item(index, dragged_item)
		print("drop item")
	elif inventory_item and dragged_item:
		drag_preview.dragged_item = Inventory.set_item(index, dragged_item)
		print("swap item")
	
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

func _on_activity_button_place_turret(turret_scene, location):
	place_turret.emit(turret_scene, location)

func _on_debug_enemy_button_pressed():
	var enemy = debug_enemy.instantiate()
	add_child(enemy)
	
