extends CanvasLayer

signal back_button_pressed()

func _ready():
	print("Settings loaded")

func _on_back_button_pressed():
	back_button_pressed.emit()
