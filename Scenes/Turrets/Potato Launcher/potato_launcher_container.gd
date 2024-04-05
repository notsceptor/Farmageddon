extends Turret

func _ready():
	turret_model = $PotatoLauncher/Node # Assign the turret model node
	shooter_node = $PotatoLauncher/Node/CarrotCannon/Aim # Assign the turret shooter node
	var turret_area_rid = $PotatoLauncher/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Potato Launcher attacking")
	$PotatoLauncher/AnimationPlayer.play("Gatling Fire") #working

func _on_potato_launcher_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_potato_launcher_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())
