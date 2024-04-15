extends Node3D
class_name EnemyParent

var in_constant_aoe_damage_zone: bool = false
var area_damage_to_take: int

var curve_3d: Curve3D

func _process(_delta):
	if WaveManager.wave_ongoing and !WaveManager.wave_won:
		GlobalAudioPlayer.play_fail_sound()
		$EnemyStateChart.send_event("to_despawning")

func _ready():
	curve_3d = Curve3D.new()
	for i in PathGenInstance.get_path_route():
		curve_3d.add_point(Vector3(i.x, 0, i.y))
		
	$Path3D.curve = curve_3d
	$Path3D/PathFollow3D.progress_ratio = 0

func _on_spawning_state_entered():
	WaveManager.enemies_on_map += 1
	$EnemyStateChart.send_event("to_moving")
	
func _on_moving_state_processing(_delta):
	if $Path3D/PathFollow3D.progress_ratio >= 1:
		$EnemyStateChart.send_event("to_despawning")
	
func _on_despawning_state_entered():
	WaveManager.wave_won = false
	queue_free()
	WaveManager.enemies_on_map -= 1

func remove_enemy():
	WaveManager.enemies_on_map -= 1
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector3(0, 0, 0),randf_range(0.2, 0.3)).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(get_node("../../../").queue_free)
	

