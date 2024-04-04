extends Node3D

signal area_entered(area)
signal area_exited(area)

func _on_area_radius_area_entered(area):
	area_entered.emit(area)

func _on_area_radius_area_exited(area):
	area_exited.emit(area)



func _on_area_entered(area):
	pass # Replace with function body.


func _on_area_exited(area):
	pass # Replace with function body.
