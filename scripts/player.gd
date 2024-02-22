extends AbsCaracter

var life_regen = 2

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
	if Input.is_action_just_pressed("player_basic_attack") && !is_attacking && !is_dashing && !is_dodging:
		$AnimationTree.get("parameters/playback").travel("basic_attack")
		is_attacking = true
		velocity = Vector2.ZERO
	elif  Input.is_action_just_pressed("player_secondary_attack") && !is_attacking && !is_dashing && !is_dodging:
		is_dashing = true
		disable_colision()
		var input_direction = Input.get_vector("player_left","player_right","player_up","player_down")
		input_direction = input_direction.normalized()
		velocity = input_direction * (speed * dashing_speed)
		$AnimationTree.get("parameters/playback").travel("player_secondary_attack")
	elif  Input.is_action_just_pressed("player_dodge") && !is_attacking && !is_dashing && !is_dodging:
		is_dodging = true
		disable_colision()
		velocity = $AnimationTree.get("parameters/idle/blend_position").normalized() * (speed * dashing_speed)
		velocity = -velocity
		$AnimationTree.get("parameters/playback").travel("dodge")
		$AnimationTree.set("parameters/dodge/blend_position",velocity)

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
		"player_basic_attack_down":
			is_attacking = false
		"player_basic_attack_left":
			is_attacking = false
		"player_basic_attack_right":
			is_attacking = false
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
	body.take_damage(randi_range(damage_range.x,damage_range.y), position, 4.0)

func _on_life_regen_timeout():
	if current_life < max_life:
		if current_life + life_regen > max_life:
			current_life = max_life
		else:
			current_life += life_regen
		emit_signal("player_life_update", current_life)
