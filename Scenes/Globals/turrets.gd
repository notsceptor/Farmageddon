extends Node

var turret_data: Dictionary = {}

func _ready():
	load_turret_data()

func load_turret_data():
	var file = FileAccess.open("res://Items/turrets.json", FileAccess.READ)
	if file != null:
		var json_content = file.get_as_text()
		turret_data = JSON.parse_string(json_content)
	else:
		printerr("Failed to open turrets.json file")

func get_turret_data(name: String) -> Dictionary:
	for rarity in turret_data.values():
		for turret in rarity:
			if turret.name == name:
				return turret.duplicate()
	return {}
