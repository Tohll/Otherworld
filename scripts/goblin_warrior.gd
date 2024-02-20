extends AbsCaracter

func _ready():
	speed = 100
	max_life = 10
	current_life = max_life
	velocity = Vector2.ZERO
	damage_indicator_position = Vector2(0,15)
	damage_color = ENEMY_WHITE

func _process(_delta):
	if !is_dead:
		set_direction_and_sprite()

func set_direction_and_sprite():
	if (is_attacking):
		show_sprite("attack_sprite")
		$AnimationTree.get("parameters/playback").travel("attack")
		return
		
	if (player):
		velocity = position.direction_to(player.position) * speed
		
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("idle")
		show_sprite("idle_sprite")
	else:
		show_sprite("move_sprite")
		$AnimationTree.get("parameters/playback").travel("walk")
		$AnimationTree.set("parameters/attack/blend_position",velocity)
		$AnimationTree.set("parameters/walk/blend_position",velocity)
		$AnimationTree.set("parameters/idle/blend_position",velocity)

func show_sprite(sprite_name):
	hide_sprites()
	match (sprite_name):
		"attack_sprite":
			get_node("attack_sprite").show()
		"move_sprite"	:
			get_node("move_sprite").show()
		"idle_sprite":
			get_node("idle_sprite").show()

func die():
	queue_free()

func hide_sprites():
	get_node("attack_sprite").hide()
	get_node("move_sprite").hide()
	get_node("idle_sprite").hide()

func _on_detection_body_entered(body):
	player = body

func _on_detection_body_exited(_body):
	player = null
	velocity = Vector2.ZERO

func _on_attack_range_body_entered(_body):
	is_attacking = true

func _on_attack_range_body_exited(_body):
	is_attacking = false

func _on_attack_zone_body_entered(body):
	if !is_dead:
		body.take_damage(randi_range(1,15))
