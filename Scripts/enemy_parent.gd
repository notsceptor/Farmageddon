extends Node3D
class_name EnemyParent

@onready var _name: String
@onready var _health: int
@onready var _size: int
@onready var _speed: int

var in_constant_aoe_damage_zone: bool = false
var area_damage_to_take: int

var curve_3d: Curve3D

func _ready():
	curve_3d = Curve3D.new()
	for i in PathGenInstance.get_path_route():
		curve_3d.add_point(Vector3(i.x, 0, i.y))
		
	$Path3D.curve = curve_3d
	$Path3D/PathFollow3D.progress_ratio = 0

func _on_spawning_state_entered():
	Globals.enemies_on_map += 1
	$EnemyStateChart.send_event("to_moving")
	
func _on_moving_state_processing(_delta):
	if $Path3D/PathFollow3D.progress_ratio >= 1:
		$EnemyStateChart.send_event("to_despawning")
	
func _on_despawning_state_entered():
	queue_free()
	Globals.enemies_on_map -= 1

func get_stats(): # Remove yellow errors since never used (just for child class)
	return [_name, _health, _size, _speed]
	
func remove_enemy():
	get_node("../../../").queue_free()
	# Death sound / animation here etc
