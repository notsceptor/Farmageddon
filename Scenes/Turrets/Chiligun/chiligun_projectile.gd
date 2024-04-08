extends Area3D

@onready var damage: int = 1
@onready var projectile_type: String = "aoe"

var enemy_list: Array[Area3D]

func _process(_delta):
	print(enemy_list)
	if enemy_list.size() > 0:
		$ChiliSpray.emitting = true
		$ChiliSpray2.emitting = true
		$ChiliSpray3.emitting = true
	else:
		$ChiliSpray.emitting = false
		$ChiliSpray2.emitting = false
		$ChiliSpray3.emitting = false

func _on_area_entered(area):
	enemy_list.append(area)

func _on_area_exited(area):
	enemy_list.erase(area)
