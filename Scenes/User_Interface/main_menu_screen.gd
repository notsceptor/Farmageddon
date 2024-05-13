extends CanvasLayer

@onready var easy_level_path: String = "res://Scenes/Maps/easy_map.tscn"
@onready var medium_level_path: String = "res://Scenes/Maps/medium_map.tscn"
@onready var hard_level_path: String = "res://Scenes/Maps/hard_map.tscn"
@onready var inventory_path: String = "res://Scenes/User_Interface/workshop_ui.tscn"
@onready var settings_path: String = "res://Scenes/User_Interface/settings_screen.tscn"

@onready var master_volume_slider = $MarginContainer/SettingsMenu/VBoxContainer/VBoxContainer/MasterVolSlider
@onready var master_volume_value = $MarginContainer/SettingsMenu/VBoxContainer/VBoxContainer/HBoxContainer/MasterVolValue
@onready var music_volume_slider = $MarginContainer/SettingsMenu/VBoxContainer/VBoxContainer2/MusicVolSlider
@onready var music_volume_value = $MarginContainer/SettingsMenu/VBoxContainer/VBoxContainer2/HBoxContainer2/MusicVolValue
@onready var sfx_volume_slider = $MarginContainer/SettingsMenu/VBoxContainer/VBoxContainer3/SfxVolSlider
@onready var sfx_volume_value = $MarginContainer/SettingsMenu/VBoxContainer/VBoxContainer3/HBoxContainer3/SfxVolValue

# Called when the node enters the scene tree for the first time.
func _ready():
	# Loading the sound values
	master_volume_slider.value = Globals.master_volume_value
	master_volume_value.text = str(Globals.master_volume_value*100)
	music_volume_slider.value = Globals.music_volume_value
	music_volume_value.text = str(Globals.music_volume_value*100)
	sfx_volume_slider.value = Globals.sfx_volume_value
	sfx_volume_value.text = str(Globals.sfx_volume_value*100)
	
	$MarginContainer.visible = false
	$MarginContainer/LevelSelectContainer.visible = false
	$BackButtonContainer.visible = false
	$MarginContainer/SettingsMenu.visible = false
	$Inventory.visible = false
	# Play main menu music here probably
	if not Globals.intro_played:
		$VideoStreamPlayer.play()
		await $VideoStreamPlayer.finished
		Globals.intro_played = true
	GlobalAudioPlayer.play_main_music()
	$MarginContainer.visible = true
	$Inventory.visible = true

func _on_play_game_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	$MarginContainer/MainScreenContainer.visible = false
	$MarginContainer/LevelSelectContainer.visible = true
	$Inventory.visible = false
	$BackButtonContainer.visible = true

func _on_easy_level_button_pressed():
	GlobalAudioPlayer.stop_main_music()
	GlobalAudioPlayer.play_menu_click_sound()
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(easy_level_path)

func _on_medium_level_button_pressed():
	GlobalAudioPlayer.stop_main_music()
	GlobalAudioPlayer.play_menu_click_sound()
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(medium_level_path)
	
func _on_hard_level_button_pressed():
	GlobalAudioPlayer.stop_main_music()
	GlobalAudioPlayer.play_menu_click_sound()
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(hard_level_path)

func _on_back_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	$MarginContainer/MainScreenContainer.visible = true
	$Inventory.visible = true
	$MarginContainer/LevelSelectContainer.visible = false
	$MarginContainer/SettingsMenu.visible = false
	$BackButtonContainer.visible = false
	
func hide_menu_screen_for_transition() -> void:
	$BackButtonContainer.visible = false
	$MarginContainer.visible = false
	
func _on_exit_game_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	get_tree().quit()

func _on_open_inventory_pressed():
	$Inventory.visible = false
	GlobalAudioPlayer.play_menu_click_sound()
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(inventory_path)

func _on_settings_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	$MarginContainer/MainScreenContainer.visible = false
	$MarginContainer/SettingsMenu.visible = true
