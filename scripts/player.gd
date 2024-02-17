extends CharacterBody2D

const speed = 200

func _process(_delta):
	get_input()

func _physics_process(_delta):
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("player_left","player_right","player_up","player_down")
	velocity = input_direction * speed
