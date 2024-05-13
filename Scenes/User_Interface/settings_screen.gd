extends CanvasLayer

signal back_button_pressed()

@onready var master_volume_slider = $MarginContainer/PanelContainer/VBoxContainer/VBoxContainer/MasterVolSlider
@onready var master_volume_value = $MarginContainer/PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/MasterVolValue

@onready var music_volume_slider = $MarginContainer/PanelContainer/VBoxContainer/VBoxContainer2/MusicVolSlider
@onready var music_volume_value = $MarginContainer/PanelContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/MusicVolValue

@onready var sfx_volume_slider = $MarginContainer/PanelContainer/VBoxContainer/VBoxContainer3/SfxVolSlider
@onready var sfx_volume_value = $MarginContainer/PanelContainer/VBoxContainer/VBoxContainer3/HBoxContainer3/SfxVolValue

func _ready():
	master_volume_slider.value = Globals.master_volume_value
	master_volume_value.text = str(Globals.master_volume_value*100)
	
	music_volume_slider.value = Globals.music_volume_value
	music_volume_value.text = str(Globals.music_volume_value*100)
	
	sfx_volume_slider.value = Globals.sfx_volume_value
	sfx_volume_value.text = str(Globals.sfx_volume_value*100)

func _on_back_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	back_button_pressed.emit()
