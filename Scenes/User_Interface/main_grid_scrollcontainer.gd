extends Control

@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var toggle_button: Button = $GridButton
@onready var scroll_container: ScrollContainer = $ScrollContainer

var is_open: bool = true
var button_initial_position: Vector2

var open_texture: StyleBoxTexture = preload("res://Scenes/User_Interface/Assets/inventory_open_texture.tres")
var closed_texture: StyleBoxTexture = preload("res://Scenes/User_Interface/Assets/inventory_close_texture.tres")

func _ready():
	toggle_button.connect("pressed", Callable(self, "_on_toggle_button_pressed"))
	button_initial_position = toggle_button.position
	update_button_icon()
	open_container()

func _on_toggle_button_pressed():
	if is_open:
		close_container()
	else:
		open_container()

func open_container():
	is_open = true
	scroll_container.visible = true
	var tween = create_tween()
	tween.parallel().tween_property(scroll_container, "position:y", 0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(toggle_button, "position:y", button_initial_position.y - scroll_container.size.y / 2, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.connect("finished", Callable(self, "_on_tween_finished").bind(tween, true))
	update_button_icon()

func close_container():
	is_open = false
	var tween = create_tween()
	tween.parallel().tween_property(scroll_container, "position:y", scroll_container.size.y, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(toggle_button, "position:y", button_initial_position.y, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "_on_tween_finished").bind(tween, false))
	update_button_icon()

func _on_tween_finished(tween: Tween, visible: bool):
	scroll_container.visible = visible
	
	
func update_button_icon():
	if is_open:
		toggle_button.add_theme_stylebox_override("normal", closed_texture)
		toggle_button.add_theme_stylebox_override("hover", closed_texture)
		toggle_button.add_theme_stylebox_override("pressed", closed_texture)
	else:
		toggle_button.add_theme_stylebox_override("normal", open_texture)
		toggle_button.add_theme_stylebox_override("hover", open_texture)
		toggle_button.add_theme_stylebox_override("pressed", open_texture)
