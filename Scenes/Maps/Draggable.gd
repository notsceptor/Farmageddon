extends Camera3D

var move_speed: float = 1.0
var dragging: bool = false
var prev_mouse_pos: Vector2

@onready var button_container = get_node("../UI/HBoxContainer")

func _ready():
	set_process_input(true)

func _input(event):
	for button in button_container.get_children():
		if button.is_dragging:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				dragging = false
			return
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				prev_mouse_pos = event.position
			else:
				dragging = false

	if dragging and event is InputEventMouseMotion:
		var delta = prev_mouse_pos - event.position
		move_camera(delta)
		prev_mouse_pos = event.position

func move_camera(delta: Vector2):
	var right = global_transform.basis.x.normalized()
	var forward = global_transform.basis.z.normalized()
	right.y = 0
	forward.y = 0
	right = right.normalized()
	forward = forward.normalized()
	
	var movement = right * delta.x * move_speed * get_process_delta_time()
	movement += forward * delta.y * move_speed * get_process_delta_time()
	
	global_position.x = clamp(global_position.x, 0, 15)
	global_position.z = clamp(global_position.z, -0, 10)
	
	global_transform.origin += movement
