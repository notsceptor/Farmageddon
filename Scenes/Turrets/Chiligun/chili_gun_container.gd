extends Turret

@onready var spray_node_one = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect/ChiliSpray
@onready var spray_node_two = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect/ChiliSpray2
@onready var spray_node_three = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect/ChiliSpray3

var enemy_list: Array[Area3D]

func _ready():
	turret_model = $Chiligun/Node # Assign the turret model node
	shooter_node = $Chiligun/Node/Chilligun/Aim # Assign the shooter node
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
	
func _maybe_fire_turret_projectile():
	$Chiligun/AnimationPlayer.play("Spray")
