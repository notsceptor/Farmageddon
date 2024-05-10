extends ProgressBar

func _ready():
	var fill_style = StyleBoxFlat.new()
	
	fill_style.bg_color = Color("debc8b")
	fill_style.corner_radius_top_left = 10
	fill_style.corner_radius_top_right = 10
	fill_style.corner_radius_bottom_right = 10
	fill_style.corner_radius_bottom_left = 10
	
	add_theme_stylebox_override("fill", fill_style)
	
	var bg_style = StyleBoxFlat.new()
	
	bg_style.bg_color = Color("00000050")
	bg_style.border_color = Color("ffffff")
	bg_style.corner_radius_top_left = 10
	bg_style.corner_radius_top_right = 10
	bg_style.corner_radius_bottom_right = 10
	bg_style.corner_radius_bottom_left = 10
	
	add_theme_stylebox_override("background", bg_style)
