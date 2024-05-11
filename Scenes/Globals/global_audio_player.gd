extends Node

# Music

func play_battle_music():
	$BattleThemeMusic.play()
	
func stop_battle_music():
	$BattleThemeMusic.stop()
	
func play_idle_music():
	$IdleThemeMusic.play()
	
func stop_idle_music():
	$IdleThemeMusic.stop()

func play_title_music():
	$TitleThemeMusic.play()
	
func stop_title_music():
	$TitleThemeMusic.stop()
	
func play_main_music():
	$MainThemeMusic.play()
	
func stop_main_music():
	$MainThemeMusic.stop()

# Sound Effects

# User Interface Sounds

func play_menu_click_sound():
	$MenuClick.pitch_scale = randf_range(1.2, 1.6)
	$MenuClick.play()
	
func play_fail_sound():
	$FailSound.play()
	
func play_placement_sound():
	$Placement.pitch_scale = randf_range(1.2, 1.3)
	$Placement.play()
	
# Monster Sounds

func play_snail_death_sound():
	$SnailDeathSound.pitch_scale = randf_range(1.1, 1.3)
	$SnailDeathSound.play()

func play_scumbug_death_sound():
	$ScumbugDeathSound.pitch_scale = randf_range(3.4, 4.1)
	$ScumbugDeathSound.play()
	
func play_beetle_death_sound():
	$BeetleDeathSound.pitch_scale = randf_range(0.7, 1.0)
	$BeetleDeathSound.play()
	
func play_earthquake_sound():
	$EarthquakeSound.play()
	
func play_fish_nom_sound():
	$FishNom.pitch_scale = randf_range(0.7, 1.0)
	$FishNom.play()
	
func play_shark_chomp_sound():
	$SharkChomp.pitch_scale = randf_range(0.7, 1.0)
	play_fish_nom_sound()
	$SharkChomp.play()

# Turret Sounds

func play_carrot_shot():
	$CarrotShot.pitch_scale = randf_range(1.3, 1.5)
	$CarrotShot.play()
	
func play_fishlauncher_shot():
	$FishLauncherShot.pitch_scale = randf_range(1.3, 1.5)
	$FishLauncherShot.play()
	
func play_haybale_shot():
	$HaybaleShot.pitch_scale = randf_range(1.3, 1.5)
	$HaybaleShot.play()
	
func play_pea_shot():
	$PeaShot.pitch_scale = randf_range(0.8, 0.9)
	$PeaShot.play()
	
func play_potato_shot():
	$PeaShot.pitch_scale = randf_range(1.3, 1.5)
	$PeaShot.play()
	
func play_seed_shot():
	$SeedShot.pitch_scale = randf_range(1.3, 1.5)
	$SeedShot.play()
	
func play_strawberry_projectile_sound():
	$StrawberryProjectile.pitch_scale = randf_range(1.2, 1.5)
	$StrawberryProjectile.play()
