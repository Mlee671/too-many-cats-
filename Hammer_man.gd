extends Node
class_name Hammer_man

const DODGE_SPRITE := preload("res://entity/main_character/dodge_placeholder.png")
const BASE_SPRITE := preload("res://entity/main_character/Arthax.png")

@export var SPEED := 200
@export var ACCEL_SMOOTH := 10 # how smooth stop/start movement

@export var EVADE_MOVEMENT_SCALING := 2.5
@export var EVADE_DURATION := 0.2
@export var EVADE_COOLDOWN := 0.5

@export var FIRE_COOLDOWN := .5 # firing cd

var max_health := 100.0
var current_health := 100.0
