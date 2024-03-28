extends CanvasLayer

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayGameButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton
@onready var exit_game_button: Button = $MarginContainer/VBoxContainer/ExitGameButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# Play main menu music here probably

func _on_play_game_button_pressed():
	$MarginContainer.visible = false
	TransitionLayer.change_scene("res://Scenes/Maps/easy_map.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()
