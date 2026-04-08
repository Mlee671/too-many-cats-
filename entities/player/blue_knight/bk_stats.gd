extends Node
class_name Stats

@export var speed := 100
@export var accel := 10 # how smooth stop/start movement

@export var evade_movement_scaling := 2.5
@export var evade_dur := 0.2
@export var evade_cd := 0.5



@export var fire_cd := .5

# player states
enum states{IDLE, RUNNING, DODGING}
@export var player_state = states.IDLE

# player stats
var shots_fired := 0
