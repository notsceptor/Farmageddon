extends Node
@onready var main_menu_path: String = "res://Scenes/User_Interface/main_menu_screen.tscn"
@onready var gacha_path: String = "res://Scenes/User_Interface/workshop_gacha.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(main_menu_path)
	
func hide_menu_screen_for_transition() -> void:
	$CanvasLayer/Turrets.visible = false
	
func _on_gacha_button_pressed():
	hide_menu_screen_for_transition()
	TransitionLayer.change_scene(gacha_path)
