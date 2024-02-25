extends Node2D

signal alch_end(spell_name: String)

var damage_range = Vector2(50,100)

func _on_area_2d_body_entered(body):
	body.take_damage(randi_range(damage_range.x,damage_range.y), global_position,"wind", 6.0)

func _on_animation_player_animation_finished(_anim_name):
	emit_signal("alch_end","wind_effect")
