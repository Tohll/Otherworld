extends Node2D

func _on_animation_player_animation_started(_anim_name):
	get_parent().hide_sprites()


func _on_animation_player_animation_finished(_anim_name):
	get_parent().die()
