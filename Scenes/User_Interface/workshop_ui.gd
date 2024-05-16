extends Node

signal close_inventory
signal open_gacha_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Background Texture".visible = false
	$CanvasLayer.visible = false

func _on_exit_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	close_inventory.emit()
	
func hide_menu_screen_for_transition() -> void:
	$CanvasLayer/Turrets.visible = false
	
func _on_gacha_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	$"Background Texture".visible = false
	$CanvasLayer.visible = false
	open_gacha_screen.emit()

func _on_workshop_gacha_open_inventory_screen():
	$CanvasLayer/Turrets/TurretsContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer.populate_grid()
	$"Background Texture".visible = true
	$CanvasLayer.visible = true
