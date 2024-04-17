extends Node

const SPAWN_RADIUS = 350
@export var basic_enemy_scene : PackedScene

@onready var timer = $Timer

var base_spawn_time = 0

func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null :
		return Vector2.ZERO
	
	#choose a random direction on 360 degrees
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = player.global_position + (random_direction*SPAWN_RADIUS)
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	owner.add_child(enemy)
	enemy.global_position = spawn_position
	
