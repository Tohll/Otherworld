extends TextureProgressBar

@onready var player = get_node("../../terrain/player")

func _ready():
	player.player_hit.connect(_on_player_player_hit)
	min_value = 0
	max_value = player.max_life
	value = max_value

func _on_player_player_hit(damages):
	value -= damages
