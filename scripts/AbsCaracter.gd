class_name AbsCaracter extends CharacterBody2D

const DAMAGE_INDICATOR = preload("res://scenes/objects/damage_indicator.tscn")
const BLOOD_EFFECT = preload("res://scenes/objects/blood_effects.tscn")
const DEATH_EFFECT = preload("res://scenes/objects/death_particles.tscn")
const PHYSICAL_DAMAGES = Color(1.0,1.0,1.0,1.0)
const WATER_DAMAGES = Color(0.0,0.0,1.0,1.0)
const FIRE_DAMAGES = Color(1.0,0.5,0.0,1.0)
const WIND_DAMAGES = Color(0.694,0.773,1.0,1.0)
const EARTH_DAMAGES = Color(0.647,0.412,0.0,1.0)
const PHYSICAL_OUTLINE = Color(0,0,0,1)
const WATER_OUTLINE = Color(0.094,0,0.616,1)
const FIRE_OUTLINE = Color(1,0,0,1)
const WIND_OUTLINE = Color(0.459,0.58,1,1)
const EARTH_OUTLINE = Color(0.463,0.2,0.039,1)

signal player_life_update(life_value: int)

var damage_range = null
var speed = null
var dashing_speed = null
var is_player = false
var is_attacking =false
var is_dead = false
var is_knockbacked = false
var is_dashing = false
var is_dodging = false
var is_comboting = false
var player = null
var max_life = null
var current_life = null
var damage_indicator_position = null
var combo_stage = 0
var max_combo = 2

func _physics_process(_delta):
	if (!is_attacking && !is_dead || is_knockbacked):
		move_and_slide()

func spawn_effect(effect: PackedScene):
	if effect:
		var effect_instance = effect.instantiate()
		add_child(effect_instance)
		return effect_instance

func take_damage(damages: int, attacker_position: Vector2, damage_type: String, knockback_strength : float = 0.0):
	if !is_dead:
		var indicator = spawn_effect(DAMAGE_INDICATOR)
		spawn_effect(BLOOD_EFFECT)
		if indicator:
			match (damage_type):
				"physical":
					indicator.set_str_color(PHYSICAL_DAMAGES)
					indicator.set_outline_color(PHYSICAL_OUTLINE)
				"wind":
					indicator.set_str_color(WIND_DAMAGES)
					indicator.set_outline_color(WIND_OUTLINE)
				"water":
					indicator.set_str_color(WATER_DAMAGES)
					indicator.set_outline_color(WATER_OUTLINE)
				"fire":
					indicator.set_str_color(FIRE_DAMAGES)
					indicator.set_outline_color(FIRE_OUTLINE)
				"earth":
					indicator.set_str_color(EARTH_DAMAGES)
					indicator.set_outline_color(EARTH_OUTLINE)
					
			indicator.position = damage_indicator_position
			indicator.set_str_text(str(damages))
			current_life = current_life - damages
			if is_player:
				emit_signal("player_life_update",current_life)
			else:
				is_knockbacked = true
				$knockback.start()
				velocity = (position - attacker_position).normalized() * (knockback_strength * speed)
			if current_life <= 0:
				current_life = 0
				death()

func death():
	get_node("Collision").set_deferred("disabled", true)
	is_dead = true
	spawn_effect(DEATH_EFFECT)
