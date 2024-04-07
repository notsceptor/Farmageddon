extends Node3D

signal area_entered(area)
signal area_exited(area)

signal damage_area_entered(area)
signal damage_area_exited(area)

# Area radius of turret
func _on_area_radius_area_entered(area):
	area_entered.emit(area)

func _on_area_radius_area_exited(area):
	area_exited.emit(area)

# Area radius of damage cone
func _on_chiligun_spray_effect_enemy_entered_damage_cone(area):
	damage_area_entered.emit(area)

func _on_chiligun_spray_effect_enemy_exited_damage_cone(area):
	damage_area_exited.emit(area)
