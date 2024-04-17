extends Node3D

class_name Turret

var enemies_in_range: Array[Node3D] = []
var current_enemy: Node3D = null
var current_enemy_targetted: bool = false
var acquire_slerp_progress: float = 0.0

var first_enemy_index: int = 0  # Potentially use them to enable target first/last enemy
var last_enemy_index: int       # Potentially use them to enable target first/last enemy

var turret_model: Node3D        # Reference to the turret model node
var shooter_node: Node3D        # Reference to the shooter node (e.g., PeaShooter)

func rotate_towards_target(rtarget, delta):
	# Get the target position on the same y-level as the turret
	var target_position = Vector3(rtarget.global_position.x, global_position.y, rtarget.global_position.z)
	
	# Calculate the direction from the shooter node to the target position
	var target_vector = shooter_node.global_position.direction_to(target_position)
	
	# Create a new basis that looks at the target vector, but only rotates on the y-axis
	var target_basis = Basis.looking_at(target_vector, Vector3.UP)
	
	# Slerp the shooter node's basis towards the target basis
	shooter_node.basis = shooter_node.basis.slerp(target_basis, acquire_slerp_progress)
	acquire_slerp_progress += delta * 5
	
	if acquire_slerp_progress > 1:
		$StateChart.send_event("to_attacking")

func _on_idle_state_processing(_delta):
	if enemies_in_range.size() > 0:
		last_enemy_index = enemies_in_range.size() - 1
		current_enemy = enemies_in_range[first_enemy_index]
		$StateChart.send_event("to_acquiring")

func _on_acquiring_state_entered():
	current_enemy_targetted = false
	acquire_slerp_progress = 0.0

func _on_acquiring_state_processing(delta):
	if current_enemy != null and enemies_in_range.has(current_enemy):
		rotate_towards_target(current_enemy, delta)
	else:
		$StateChart.send_event("to_idle")

func _on_attacking_state_physics_processing(_delta):
	if current_enemy != null and enemies_in_range.has(current_enemy):
		shooter_node.look_at(Vector3(current_enemy.global_position.x, shooter_node.global_position.y, current_enemy.global_position.z), Vector3.UP)
		_maybe_fire_turret_projectile()
	else:
		$StateChart.send_event("to_idle")

func _maybe_fire_turret_projectile():
	# Override in child class -> Here to be able to use in function for all classes however so you do not
	# need to add _on_attacking_state_physics_processing to ALL child classes in order to fire
	pass
