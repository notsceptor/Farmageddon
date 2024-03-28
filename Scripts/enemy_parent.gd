extends Node3D
class_name EnemyParent

@onready var _name: String
@onready var _health: int
@onready var _size: int
@onready var _speed: float

var curve_3d: Curve3D

func _ready():
	curve_3d = Curve3D.new()
	for i in PathGenInstance.get_path_route():
		curve_3d.add_point(Vector3(i.x, 0, i.y))
		
	$Path3D.curve = curve_3d
	$Path3D/PathFollow3D.progress_ratio = 0

func _on_spawning_state_entered():
	Globals.enemies_on_map += 1
	# Maybe a spawn animation to delay movement -> For now it's an await as placeholder
	await get_tree().create_timer(0.5).timeout
	$EnemyStateChart.send_event("to_moving")
	
func _on_moving_state_processing(_delta):
	if $Path3D/PathFollow3D.progress_ratio >= 1:
		$EnemyStateChart.send_event("to_despawning")
	
func _on_despawning_state_entered():
	# Maybe a despawn animation to delay despawning -> For now it's an await as placeholder
	await get_tree().create_timer(0.5).timeout
	queue_free()
	Globals.enemies_on_map -= 1
	
func get_enemy_name() -> String:
	return _name
	
func get_health() -> int:
	return _health
	
func get_size() -> int:
	return _size
	
func get_speed() -> float:
	return _speed
