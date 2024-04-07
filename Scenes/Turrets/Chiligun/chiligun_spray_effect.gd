extends Node3D

signal enemy_entered(area)
signal enemy_exited(area)

signal enemy_entered_damage_cone(area)
signal enemy_exited_damage_cone(area)

func _on_damage_radius_area_entered(area):
	enemy_entered_damage_cone.emit(area)

func _on_damage_radius_area_exited(area):
	enemy_exited_damage_cone.emit(area)
