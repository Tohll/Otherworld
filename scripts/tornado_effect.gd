extends Area2D

signal alch_end(spell_name: String)

var damage_range = Vector2(100,200)
var speed = 400
var velocity = Vector2.ZERO

func _ready():
	$effect_end.start()
	
func _physics_process(delta):
	position += velocity.normalized() * speed * delta
	
func _on_area_2d_body_entered(body):
	body.take_damage(randi_range(damage_range.x,damage_range.y), global_position,"wind", 4.0)

func _on_effect_end_timeout():
	emit_signal("alch_end","tornado_effect")
