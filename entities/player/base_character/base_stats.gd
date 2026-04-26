extends Node
class_name Stats

const dodge_speed = 100
const dodge_accel = 50

var speed := 100
var accel := 20 # how smooth stop/start movement
var hp := 100

var evade_movement_scaling := 1.75
var evade_dur := 0.4
var evade_cd := 0.5

var fire_cd := .5
var ability_cd := 10

var projectile_frame := 2

# player stats
var shots_fired := 0

func get_hp():
	return hp
	
