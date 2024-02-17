extends CharacterBody2D

const speed = 200

func _process(_delta):
	get_input()

func _physics_process(_delta):
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("player_left","player_right","player_up","player_down")
	input_direction = input_direction.normalized()
	velocity = input_direction * speed
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("idle")
	else:
		$AnimationTree.get("parameters/playback").travel("run")
		$AnimationTree.set("parameters/run/blend_position",velocity)
		$AnimationTree.set("parameters/idle/blend_position",velocity)
