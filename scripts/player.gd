extends CharacterBody2D

const speed = 200
var is_attacking = false

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
		velocity = input_direction * speed
		if velocity == Vector2.ZERO:
			$AnimationTree.get("parameters/playback").travel("idle")
		else:
			$AnimationTree.get("parameters/playback").travel("run")
			$AnimationTree.set("parameters/run/blend_position",velocity)
			$AnimationTree.set("parameters/idle/blend_position",velocity)
			$AnimationTree.set("parameters/basic_attack/blend_position",velocity)


func _on_animation_tree_animation_finished(anim_name):
	is_attacking = false
