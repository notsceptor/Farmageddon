extends Turret

var turret_range: float = 2.0

func _ready():
	super._ready()
	turret_model = $CarrotCannon/Node  # Assign the turret model node
	shooter_node = $CarrotCannon/Node/CarrotCannon/CannonTop # Assign the shooter node

func _on_attacking_state_entered():
	print("Carrot Cannon attacking")
