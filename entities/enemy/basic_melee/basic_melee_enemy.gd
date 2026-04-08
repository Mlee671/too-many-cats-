extends Enemy
class_name BasicMeleeEnemy

@export var speed := 30.0
@export var acceleration := 10.0 
@export var wander_range := 6
@export var hp := 100

func _ready() -> void:
	move_speed = speed
	accel = acceleration
	pathfind_range = wander_range
	health.set_health(hp)
	super._ready()

func attack_logic() -> void:
	pass
