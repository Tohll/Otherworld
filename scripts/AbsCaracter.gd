class_name AbsCaracter extends CharacterBody2D

const DAMAGE_INDICATOR = preload("res://scenes/objects/damage_indicator.tscn")
const BLOOD_EFFECT = preload("res://scenes/objects/blood_effects.tscn")
const DEATH_EFFECT = preload("res://scenes/objects/death_particles.tscn")
const ENEMY_WHITE = Color(1.0,1.0,1.0,1.0)

signal player_life_update(life_value: int)

var speed = null
var dashing_speed = null
var is_player = false
var is_attacking =false
var is_dead = false
var is_knockbacked = false
var is_dashing = false
var player = null
var max_life = null
var current_life = null
var damage_indicator_position = null
var damage_color = null
var knockback_vulnerability = 0

func _physics_process(_delta):
	if (!is_attacking && !is_dead || is_knockbacked):
		move_and_slide()

func spawn_effect(effect: PackedScene):
	if effect:
		var effect_instance = effect.instantiate()
		add_child(effect_instance)
		return effect_instance

func take_damage(damages: int, attacker_position: Vector2):
	if !is_dead:
		var indicator = spawn_effect(DAMAGE_INDICATOR)
		spawn_effect(BLOOD_EFFECT)
		if indicator:
			indicator.position = damage_indicator_position
			indicator.set_str_text(str(damages))
			if damage_color:
				indicator.set_str_color(damage_color)
			current_life = current_life - damages
			if is_player:
				emit_signal("player_life_update",current_life)
			else:
				is_knockbacked = true
				$knockback.start()
				velocity = (position - attacker_position).normalized() * (knockback_vulnerability * speed)
			if current_life <= 0:
				current_life = 0
				death()

func death():
	get_node("Collision").set_deferred("disabled", true)
	is_dead = true
	spawn_effect(DEATH_EFFECT)
