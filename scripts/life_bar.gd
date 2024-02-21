extends TextureProgressBar

func _ready():
	min_value = 0

func _on_player_player_ready(max_life):
	max_value = max_life
	value = max_value

func _on_player_player_life_update(life_value):
	value = life_value
