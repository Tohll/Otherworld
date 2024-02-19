extends CharacterBody2D

const SPEED = 200
const DAMAGE_INDICATOR = preload("res://scenes/objects/damage_indicator.tscn")

var is_attacking = false

signal player_hit

func _process(_delta):
	get_input()

func _physics_process(_delta):
	move_and_slide()
	
func get_input():
	if Input.is_action_just_pressed("player_basic_attack"):
		$AnimationTree.get("parameters/playback").travel("basic_attack")
		is_attacking = true
		velocity = Vector2.ZERO
	if (!is_attacking):
		var input_direction = Input.get_vector("player_left","player_right","player_up","player_down")
		input_direction = input_direction.normalized()
		velocity = input_direction * SPEED
		if velocity == Vector2.ZERO:
			$AnimationTree.get("parameters/playback").travel("idle")
		else:
			$AnimationTree.get("parameters/playback").travel("run")
			$AnimationTree.set("parameters/run/blend_position",velocity)
			$AnimationTree.set("parameters/idle/blend_position",velocity)
			$AnimationTree.set("parameters/basic_attack/blend_position",velocity)

func spawn_effect(effect: PackedScene):
	if effect:
		var effect_instance = effect.instantiate()
		add_child(effect_instance)
		effect_instance.position = Vector2(0,10)
		return effect_instance

func take_damage(damages):
	var indicator = spawn_effect(DAMAGE_INDICATOR)
	if indicator:
		indicator.set_str_text(str(damages))

func _on_animation_tree_animation_finished(_anim_name):
	is_attacking = false
