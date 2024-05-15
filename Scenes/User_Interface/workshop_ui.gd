extends Node
@onready var main_menu_path: String = "res://Scenes/User_Interface/main_menu_screen.tscn"
@onready var gacha_path: String = "res://Scenes/User_Interface/workshop_gacha.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAudioPlayer.play_title_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	GlobalAudioPlayer.stop_title_music()
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(main_menu_path)
	
func hide_menu_screen_for_transition() -> void:
	$CanvasLayer/Turrets.visible = false
	
func _on_gacha_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(gacha_path)
