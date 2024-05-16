extends PanelContainer

@onready var turrets_placed = $HBoxContainer/TurretsPlaced
@onready var max_turrets = $HBoxContainer/MaxTurrets

func _process(_delta):
	if visible and !WaveManager.wave_ongoing:
		max_turrets.text = str(Globals.current_max_turrets)
		turrets_placed.text = str(Globals.current_placed_turrets)
