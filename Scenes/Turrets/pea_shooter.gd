extends Turret

var turret_range: float = 4.0

func _ready():
	super._ready()
	turret_model = $PeaShooter/Node  # Assign the turret model node
	shooter_node = $PeaShooter/Node/PeaShooter/ShooterTop  # Assign the shooter node

func _on_attacking_state_entered():
	print("Pea shooter attacking")
