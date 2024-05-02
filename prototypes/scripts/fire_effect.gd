extends Area2D

signal alch_end(spell_name: String)

var damage_range = Vector2(100,200)

func _on_body_entered(body):
	body.take_damage(randi_range(damage_range.x,damage_range.y), global_position,"fire", 7.0)

func _on_animation_player_animation_finished(anim_name):
	emit_signal("alch_end","fire_effect")
