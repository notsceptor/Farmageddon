extends Node

signal close_gacha
signal open_inventory_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Background Texture".visible = false
	$CanvasLayer.visible = false

func _on_exit_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	close_gacha.emit()
	
func hide_menu_screen_for_transition() -> void:
	$CanvasLayer.visible = false

func _on_inv_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	$"Background Texture".visible = false
	$CanvasLayer.visible = false
	open_inventory_screen.emit()

func _on_workshop_ui_open_gacha_screen():
	$"Background Texture".visible = true
	$CanvasLayer.visible = true
