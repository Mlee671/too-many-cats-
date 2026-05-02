extends Node
class_name Stats

const dodge_speed = 150.0
const dodge_accel = 80.0
const evade_dur = 0.5
var evade_cd := 1

const accel = 40

@export var speed := 200
var hp := 100
var max_hp :=100


var fire_cd := .5
var ability_cd := 10
var current_ability_cd = 10

# which bullet sprite to use
var projectile_frame := 2
var projectile_speed := 200
var projectile_knockback := 80

var damage := 10

# player stats
var shots_fired := 0

func get_hp():
	return hp
	
