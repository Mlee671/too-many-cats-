extends Node
class_name Stats

var speed := 100
var accel := 10 # how smooth stop/start movement
var hp := 100

const evade_movement_scaling := 5
var evade_dur := 0.4
var evade_cd := 0.5

var fire_cd := .5
var ability_cd := 10

var projectile_frame := 2

# player states
enum states{IDLE, RUNNING, DODGING}
var player_state = states.IDLE

# player stats
var shots_fired := 0

func get_hp():
	return hp
	
