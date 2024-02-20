extends CharacterBody2D

var speed = 100
var is_attacking
var player = null

const DAMAGE_INDICATOR = preload("res://scenes/objects/damage_indicator.tscn")
const ENEMY_GRAY = Color(0.9,0.9,0.9,1.0)

func _ready():
	velocity = Vector2.ZERO
	is_attacking = false

func _process(_delta):
	set_direction_and_sprite()
	
func _physics_process(_delta):
	if (!is_attacking):
		move_and_slide()
	
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
	get_node("attack_sprite").hide()
	get_node("move_sprite").hide()
	get_node("idle_sprite").hide()
	
	match (sprite_name):
		"attack_sprite":
			get_node("attack_sprite").show()
		"move_sprite"	:
			get_node("move_sprite").show()
		"idle_sprite":
			get_node("idle_sprite").show()

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
		indicator.set_str_color(ENEMY_GRAY)

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
	body.take_damage(randi_range(1,15))
