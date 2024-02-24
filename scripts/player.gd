extends AbsCaracter

const WIND_EFFECT = preload("res://scenes/objects/wind_effect.tscn")

var life_regen = 2
var last_attack = null
var current_alch_effect = null

signal player_death
signal player_ready(max_life: int)

func _ready():
	speed = 200
	dashing_speed = 2
	max_life = 200
	current_life = max_life
	damage_indicator_position = Vector2(0,10)
	velocity = Vector2.ZERO
	is_player = true
	damage_range = Vector2(5,9)
	emit_signal("player_ready", max_life)

func _process(_delta):
	if !is_dead:
		get_input()

func get_input():
	attacks_and_specials()
	movements()

func hide_sprites():
	get_node("player_sheet").hide()

func attacks_and_specials():
	if Input.is_action_just_pressed("player_dodge") && !is_dashing && !is_dodging:
		dodging()
		return
	if !is_comboting:
		if Input.is_action_just_pressed("player_basic_attack") && !is_attacking && !is_dashing && !is_dodging:
			$AnimationTree.get("parameters/playback").travel("basic_attack")
			is_attacking = true
			velocity = Vector2.ZERO
		elif  Input.is_action_just_pressed("player_secondary_attack") && !is_attacking && !is_dashing && !is_dodging:
			#implement secondary later
			pass
	else:
		match (last_attack):
			"basic":
				if Input.is_action_just_pressed("player_basic_attack") && !is_attacking && !is_dashing && !is_dodging:
					$AnimationTree.set("parameters/normal_C1/blend_position",$AnimationTree.get("parameters/basic_attack/blend_position").normalized())
					is_attacking = true
					$AnimationTree.get("parameters/playback").travel("normal_C1")
					return
				if Input.is_action_just_pressed("alch_0") && !is_attacking && !is_dashing && !is_dodging:
					is_attacking = true
					current_alch_effect = spawn_effect(WIND_EFFECT)
					current_alch_effect.connect("alch_end",alchemy_end)
					return
			"wind_effect":
				if Input.is_action_just_pressed("player_secondary_attack") && !is_attacking && !is_dashing && !is_dodging:
					dashing()
					return

func alchemy_end(spell_name):
	is_attacking = false
	is_comboting =true
	last_attack = spell_name
	$combo.start()
	current_alch_effect.disconnect("alch_end",alchemy_end)
	current_alch_effect.queue_free()
	current_alch_effect = null
	print(last_attack)

func dodging():
	is_attacking = false
	is_dodging = true
	disable_colision()
	velocity = $AnimationTree.get("parameters/idle/blend_position").normalized() * (speed * dashing_speed)
	velocity = -velocity
	$AnimationTree.get("parameters/playback").travel("dodge")
	$AnimationTree.set("parameters/dodge/blend_position",velocity)

func dashing():
	is_dashing = true
	disable_colision()
	velocity = $AnimationTree.get("parameters/idle/blend_position").normalized() * (speed * dashing_speed)
	$AnimationTree.get("parameters/playback").travel("player_secondary_attack")

func movements():
	if (!is_attacking && !is_dashing && !is_dodging):
		var input_direction = Input.get_vector("player_left","player_right","player_up","player_down")
		input_direction = input_direction.normalized()
		velocity = input_direction * speed
		if velocity == Vector2.ZERO:
			$AnimationTree.get("parameters/playback").travel("idle")
		else:
			$AnimationTree.get("parameters/playback").travel("run")
			$AnimationTree.set("parameters/run/blend_position",velocity)
			$AnimationTree.set("parameters/idle/blend_position",velocity)
			$AnimationTree.set("parameters/basic_attack/blend_position",velocity)

func die():
	emit_signal("player_death")

func disable_colision():
	for creep in get_tree().get_nodes_in_group("creeps"):
			add_collision_exception_with(creep)

func enable_colision():
	for creep in get_tree().get_nodes_in_group("creeps"):
			remove_collision_exception_with(creep)

func _on_animation_tree_animation_finished(anim_name):
	match (anim_name):
		"player_basic_attack_up":
			is_attacking = false
			is_comboting = true
			last_attack = "basic"
			$combo.start()
		"player_basic_attack_down":
			is_attacking = false
			is_comboting = true
			last_attack = "basic"
			$combo.start()
		"player_basic_attack_left":
			is_attacking = false
			is_comboting = true
			last_attack = "basic"
			$combo.start()
		"player_basic_attack_right":
			is_attacking = false
			is_comboting = true
			last_attack = "basic"
			$combo.start()
		"player_normal_attack_C1_down":
			is_attacking = false
			is_comboting =false
		"player_normal_attack_C1_up":
			is_attacking = false
			is_comboting =false
		"player_normal_attack_C1_left":
			is_attacking = false
			is_comboting =false
		"player_normal_attack_C1_right":
			is_attacking = false
			is_comboting =false
		"player_secondary_attack":
			enable_colision()
			velocity = Vector2.ZERO
			is_dashing = false
		"player_dodge_up":
			is_dodging = false
			enable_colision()
		"player_dodge_down":
			is_dodging = false
			enable_colision()
		"player_dodge_left":
			is_dodging = false
			enable_colision()
		"player_dodge_right":
			is_dodging = false
			enable_colision()

func _on_basic_attack_zone_body_entered(body):
	body.take_damage(randi_range(damage_range.x,damage_range.y), position, 5.0)

func _on_life_regen_timeout():
	if current_life < max_life:
		if current_life + life_regen > max_life:
			current_life = max_life
		else:
			current_life += life_regen
		emit_signal("player_life_update", current_life)

func _on_combo_timeout():
	is_comboting = false
	last_attack = null
