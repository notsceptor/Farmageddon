extends Projectile

func _ready():
	super._ready()
	damage = 5

func _on_area_entered(_area):
	GlobalAudioPlayer.play_fish_nom_sound()
	queue_free()
