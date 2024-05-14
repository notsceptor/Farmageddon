extends Area3D

var damage = null

var enemy_list: Array[Area3D]

func _ready():
	Globals.turret_rid_list.append(get_rid())

func _process(_delta):
	if enemy_list.size() > 0:
		$SporeSpray.emitting = true
		$SporeSpray2.emitting = true
	else:
		$SporeSpray.emitting = false
		$SporeSpray2.emitting = false

func _on_area_entered(area):
	enemy_list.append(area)

func _on_area_exited(area):
	enemy_list.erase(area)
