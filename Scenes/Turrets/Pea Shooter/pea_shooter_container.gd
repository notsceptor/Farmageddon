extends Turret

func _ready():
	turret_model = $PeaShooter/Node  # Assign the turret model node
	shooter_node = $PeaShooter/Node/PeaShooter/ShooterTop  # Assign the shooter node
	var turret_area_rid = $PeaShooter/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Pea shooter attacking")
	
func _on_pea_shooter_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_pea_shooter_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())
