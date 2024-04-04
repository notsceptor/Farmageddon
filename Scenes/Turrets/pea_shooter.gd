extends Turret

func _ready():
	super._ready()
	turret_model = $Node  # Assign the turret model node
	shooter_node = $Node/PeaShooter/ShooterTop  # Assign the shooter node

func _on_attacking_state_entered():
	print("Pea shooter attacking")
