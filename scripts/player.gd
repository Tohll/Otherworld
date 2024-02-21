extends AbsCaracter

var life_regen = 2

signal player_death
signal player_ready(max_life: int)

func _ready():
	speed = 200
	max_life = 200
	current_life = max_life
	damage_indicator_position = Vector2(0,10)
	velocity = Vector2.ZERO
	is_player = true
	emit_signal("player_ready", max_life)

func _process(_delta):
	if !is_dead:
		get_input()

func get_input():
	if Input.is_action_just_pressed("player_basic_attack"):
		$AnimationTree.get("parameters/playback").travel("basic_attack")
		is_attacking = true
		velocity = Vector2.ZERO
	if (!is_attacking):
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

func hide_sprites():
	get_node("player_sheet").hide()

func die():
	emit_signal("player_death")

func _on_animation_tree_animation_finished(_anim_name):
	is_attacking = false

func _on_basic_attack_zone_body_entered(body):
	body.take_damage(randi_range(5,9), position)

func _on_life_regen_timeout():
	if current_life < max_life:
		if current_life + life_regen > max_life:
			current_life = max_life
		else:
			current_life += life_regen
		emit_signal("player_life_update", current_life)
