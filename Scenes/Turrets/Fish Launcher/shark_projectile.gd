extends Projectile

func _ready():
	super._ready()
	damage = 50

func _on_area_entered(_area):
	GlobalAudioPlayer.play_shark_chomp_sound()
	queue_free()
