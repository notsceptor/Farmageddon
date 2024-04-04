extends Turret

func _ready():
	turret_model = $Chiligun/Node # Assign the turret model node
	shooter_node = $Chiligun/Node/CarrotCannon/CannonTop # Assign the shooter node
	var turret_area_rid = $Chiligun/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Chiligun attacking")

func _on_chiligun_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_chiligun_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())
