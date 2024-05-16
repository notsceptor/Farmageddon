extends Node3D
class_name MapParent

@onready var cam = $Camera3D
var RAYCAST_LENGTH:float = 100

@onready var current_level_wave_number_label: Label = $UI/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $UI/MarginContainer2/StartWaveButton

signal wave_ended

# THESE VARIABLES NEED TO BE ASSIGNED WHENEVER LEVELS
# ARE ADDED IN CODE ON THE MAIN NODE RIGHT SIDE
@export var tile_start:PackedScene
@export var tile_end:PackedScene
@export var tile_straight:PackedScene
@export var tile_corner:PackedScene
@export var tile_crossroads:PackedScene
@export var tile_empty:Array[PackedScene]

func _ready():
	Globals.current_placed_turrets = 0	
	EventBus.connect("place_turret", Callable(self, "place_turret"))

func _process(_delta):
	if WaveManager.wave_ongoing:
		if $UI/Inventory.is_open:
			$UI/Inventory.close_container()
			await $UI/Inventory.tween_finished
		$UI/Inventory.visible = false
		WaveManager.check_win_loss_conditions()
		if WaveManager.enemies_on_map == 0 and !WaveManager.wave_ongoing:
			wave_ended.emit()
			if WaveManager.current_level != 1 and (WaveManager.current_level - 1) % 5 == 0 and WaveManager.wave_won:
				CurrencyDistributor.addGems(50)
	else:
		$UI/Inventory.visible = true

func _complete_grid():
	for x in range(PathGenInstance.path_config.map_length):
		for y in range(PathGenInstance.path_config.map_height):
			if not PathGenInstance.get_path_route().has(Vector2i(x,y)):
				var tile:Node3D = tile_empty.pick_random().instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
				tile.global_rotation_degrees = Vector3(0, randi_range(0,3)*90, 0)
	
	for i in range(PathGenInstance.get_path_route().size()):
		var tile_score:int = PathGenInstance.get_tile_score(i)
		
		var tile:Node3D = tile_empty[0].instantiate()
		var tile_rotation: Vector3 = Vector3.ZERO
		
		if tile_score == 2:
			tile = tile_end.instantiate()
			tile_rotation = Vector3(0,-90,0)
		elif tile_score == 8:
			tile = tile_start.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 10:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 1 or tile_score == 4 or tile_score == 5:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 6:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,180,0)
		elif tile_score == 12:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 9:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 3:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,270,0)
		elif tile_score == 15:
			tile = tile_crossroads.instantiate()
			tile_rotation = Vector3(0,0,0)
			
		add_child(tile)
		tile.global_position = Vector3(PathGenInstance.get_path_tile(i).x, 0, PathGenInstance.get_path_tile(i).y)
		tile.global_rotation_degrees = tile_rotation
	
func _regenerate_new_map_layout():
	GlobalAudioPlayer.play_earthquake_sound()
	var scene_to_load: String
	$UI/CurrencyDisplay.visible = false
	$UI/MarginContainer.visible = false
	$UI/MarginContainer2.visible = false
	$UI/MarginContainer3.visible = false
	$UI/ReloadSceneText.visible = true
	match Globals.current_selected_map:
		"easy":
			scene_to_load = "res://Scenes/Maps/easy_map.tscn"
		"medium":
			scene_to_load = "res://Scenes/Maps/medium_map.tscn"
		"hard":
			scene_to_load = "res://Scenes/Maps/hard_map.tscn"
	TransitionLayer.reload_level(scene_to_load)

func place_turret(turret_scene, location, item_data):
	if Globals.current_placed_turrets < Globals.current_max_turrets:
		Globals.current_placed_turrets += 1
		print("Placing turret at location: ", location)
		var turret_to_add = turret_scene.instantiate()
		$Turrets.add_child(turret_to_add)
		turret_to_add.global_position = location
		turret_to_add.damage = item_data.damage
	else:
		print("AT MAX TURRET CAPACITY")

func _on_pause_screen_continue_game_button_pressed():
	get_tree().paused = false
	$PauseScreen.visible = false
	$UI.visible = true
	
func _on_ui_next_wave_button_pressed():
	if Globals.current_placed_turrets > 0:
		next_wave_button.visible = false
		WaveManager.start_wave()

func _on_ui_confirmed_rewards():
	current_level_wave_number_label.text = str(WaveManager.current_level)
	if WaveManager.current_level != 1 and (WaveManager.current_level - 1) % 5 == 0 and WaveManager.wave_won:
		_regenerate_new_map_layout()
		remove_turrets_from_map()

func _on_ui_open_pause_menu():
	get_tree().paused = true
	$PauseScreen.visible = true
	$UI.visible = false
	GlobalAudioPlayer.play_menu_click_sound()

func _on_pause_screen_settings_button_pressed():
	$PauseScreen.visible = false
	$SettingsScreen.visible = true

func _on_settings_screen_back_button_pressed():
	$SettingsScreen.visible = false
	$PauseScreen.visible = true
	
func _on_ui_pickup_turrets(): 
	remove_turrets_from_map()
		
func remove_turrets_from_map() -> void:
	Globals.current_placed_turrets = 0
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	for turret in $Turrets.get_children():
		turret.queue_free()

func _on_ui_open_inventory():
	$UI.visible = false
	$"Workshop UI/Background Texture".visible = true
	$"Workshop UI/CanvasLayer".visible = true

func _on_workshop_ui_close_inventory():
	$UI/Inventory/ScrollContainer/GridContainer.populate_grid()
	$UI.visible = true
	$"Workshop UI/Background Texture".visible = false
	$"Workshop UI/CanvasLayer".visible = false

func _on_workshop_gacha_close_gacha():
	$UI/Inventory/ScrollContainer/GridContainer.populate_grid()
	$UI.visible = true
	$"WorkshopGacha/Background Texture".visible = false
	$"WorkshopGacha/CanvasLayer".visible = false

func _on_pause_screen_main_menu_button_pressed():
	remove_turrets_from_map()
