extends Node

@onready var main_menu_path: String = "res://Scenes/User_Interface/main_menu_screen.tscn"
@onready var gacha_path: String = "res://Scenes/User_Interface/workshop_gacha.tscn"
@onready var hotbar_container: HBoxContainer = $CanvasLayer/Turrets/HotbarContainer/PanelContainer/MarginContainer/HBoxContainer

func _ready():
	for i in range(6):
		var activity_button = preload("res://Scenes/User_Interface/activity_button.tscn").instantiate()
		activity_button.enable_drag_and_drop = false
		hotbar_container.add_child(activity_button)
		
	hotbar_container.populate_hotbar()

func _on_exit_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(main_menu_path)

func hide_menu_screen_for_transition() -> void:
	$CanvasLayer/Turrets.visible = false

func _on_gacha_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(gacha_path)
