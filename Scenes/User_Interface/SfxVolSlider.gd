extends HSlider

@export var bus_name: String

var bus_index: int

@onready var sfx_volume_value = $"../HBoxContainer3/SfxVolValue"

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	sfx_volume_value.text = str(value*100)
