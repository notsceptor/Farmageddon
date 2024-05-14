extends Turret

@onready var spray_node_one = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect/ChiliSpray
@onready var spray_node_two = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect/ChiliSpray2
@onready var spray_node_three = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect/ChiliSpray3
@onready var chiligun_spray = $Chiligun/Node/Chilligun/Aim/ChiligunSprayEffect

var enemy_list: Array[Area3D]
var damage = null

func _ready():
	GlobalAudioPlayer.play_placement_sound()
	turret_model = $Chiligun/Node # Assign the turret model node
	shooter_node = $Chiligun/Node/Chilligun/Aim # Assign the shooter node
	var turret_area_rid = $Chiligun/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	
func _on_chiligun_area_entered(area):
	chiligun_spray.damage = damage
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	
func _on_chiligun_area_exited(area):
	enemies_in_range.erase(area)
	
func _maybe_fire_turret_projectile():
	$Chiligun/AnimationPlayer.play("Spray")

