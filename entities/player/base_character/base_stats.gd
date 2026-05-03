extends Node
class_name Stats
# All dur/cd measurements are in seconds


# Constant across all characters
const dodge_speed = 250.0
const dodge_accel = 80.0
var evade_dur = 0.4
var evade_cd := 1

const accel = 40

var swap_dur = 0.5


# Var dependent on charcter

@export var speed := 200
var hp := 100
var max_hp :=100
var evade_movement_scaling = 1.75


var fire_cd := .5
var ability_cd := 10
var ability_dur = 1
var current_ability_cd = 10

# which bullet sprite to use
var projectile_frame := 2
var projectile_speed := 200
var projectile_knockback := 0

var damage := 10

# player stats
var shots_fired := 0

var attack_sfx :="pop_1"
func get_hp():
	return hp
	
