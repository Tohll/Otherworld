class_name AbsCaracter extends CharacterBody2D

const DAMAGE_INDICATOR = preload("res://scenes/objects/damage_indicator.tscn")
const BLOOD_EFFECT = preload("res://scenes/objects/blood_effects.tscn")
const DEATH_EFFECT = preload("res://scenes/objects/death_particles.tscn")
const ENEMY_WHITE = Color(1.0,1.0,1.0,1.0)

var speed
var is_attacking =false
var is_dead = false
var player = null
var max_life
var current_life
var damage_indicator_position
var damage_color = null

func _physics_process(_delta):
	if (!is_attacking && !is_dead):
		move_and_slide()

func spawn_effect(effect: PackedScene):
	if effect:
		var effect_instance = effect.instantiate()
		add_child(effect_instance)
		return effect_instance

func take_damage(damages: int):
	if !is_dead:
		var indicator = spawn_effect(DAMAGE_INDICATOR)
		spawn_effect(BLOOD_EFFECT)
		if indicator:
			indicator.position = damage_indicator_position
			indicator.set_str_text(str(damages))
			if damage_color:
				indicator.set_str_color(damage_color)
			current_life = current_life - damages
			if current_life <= 0:
				current_life = 0
				death()

func death():
	get_node("Collision").set_deferred("disabled", true)
	is_dead = true
	spawn_effect(DEATH_EFFECT)
