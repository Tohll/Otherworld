extends Node2D

func _on_animation_player_animation_started(anim_name):
	get_parent().hide_sprites()# Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	get_parent().die()
