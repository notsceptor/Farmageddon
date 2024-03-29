extends CanvasLayer

@onready var easy_level_path: String = "res://Scenes/Maps/easy_map.tscn"
@onready var medium_level_path: String = "res://Scenes/Maps/medium_map.tscn"
@onready var hard_level_path: String = "res://Scenes/Maps/hard_map.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play main menu music here probably
	$MarginContainer/LevelSelectContainer.visible = false
	$BackButtonContainer.visible = false

func _on_play_game_button_pressed():
	$MarginContainer/MainScreenContainer.visible = false
	$MarginContainer/LevelSelectContainer.visible = true
	$BackButtonContainer.visible = true

func _on_easy_level_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(easy_level_path)

func _on_medium_level_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(medium_level_path)
	
func _on_hard_level_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(hard_level_path)

func _on_back_button_pressed():
	$MarginContainer/MainScreenContainer.visible = true
	$MarginContainer/LevelSelectContainer.visible = false
	$BackButtonContainer.visible = false
	
func hide_menu_screen_for_transition() -> void:
	$BackButtonContainer.visible = false
	$MarginContainer.visible = false
	
func _on_exit_game_button_pressed():
	get_tree().quit()
