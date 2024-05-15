extends Area3D

@onready var burn = $burn

var enemy_list: Array[Area3D]
var damage = null

func _ready():
	Globals.turret_rid_list.append(get_rid())

func _process(_delta):
	if enemy_list.size() > 0:
		$ChiliSpray.emitting = true
		$ChiliSpray2.emitting = true
		$ChiliSpray3.emitting = true
		if not burn.playing:
			burn.play()
	else:
		$ChiliSpray.emitting = false
		$ChiliSpray2.emitting = false
		$ChiliSpray3.emitting = false
		if burn.playing:
			burn.stop()

func _on_area_entered(area):
	enemy_list.append(area)

func _on_area_exited(area):
	enemy_list.erase(area)
