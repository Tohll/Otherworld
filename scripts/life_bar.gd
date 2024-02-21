extends TextureProgressBar

func _ready():
	min_value = 0

func _on_player_player_hit(damages):
	value -= damages

func _on_player_player_ready(max_life):
	max_value = max_life
	value = max_value
