extends Control

@onready var information_label = $Information

# Called when the node enters the scene tree for the first time.
func _ready():
	information_label.hide()

func start_wave_display():
	information_label.text = "INCOMING WAVE"
	information_label.show()
	information_label.modulate = Color(1, 1, 1, 0)
	information_label.rect_scale = Vector2(2, 2)
	
	var tween = create_tween()
	tween.tween_property(information_label, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_property(information_label, "rect_scale", Vector2(1, 1), 1.0)
	tween.tween_delay(2.0)
	tween.tween_property(information_label, "modulate", Color(1, 1, 1, 0), 1.0)
	tween.connect("finished", Callable(self, "_on_tween_completed"))

func start_boss_wave_display():
	information_label.text = "INCOMING BOSS WAVE"
	information_label.show()
	information_label.modulate = Color(1, 1, 1, 0)
	information_label.rect_scale = Vector2(2, 2)
	
	var tween = create_tween()
	tween.tween_property(information_label, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_property(information_label, "rect_scale", Vector2(1, 1), 1.0)
	tween.tween_delay(2.0)
	tween.tween_property(information_label, "modulate", Color(1, 1, 1, 0), 1.0)
	tween.connect("finished", Callable(self, "_on_tween_completed"))

func _on_tween_completed():
	information_label.hide()
