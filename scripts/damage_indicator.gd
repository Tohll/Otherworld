extends Node2D

func set_str_text(string):
	$Label.text = string
	
func set_str_color(color: Color):
	$Label.set("theme_override_colors/font_color",color)
