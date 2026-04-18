extends Stats

var ability_dur := 5.0

func _ready() -> void:
	speed = 70
	accel = 10 # how smooth stop/start movement
	hp = 150
	
	evade_movement_scaling = 1.75
	evade_dur = 0.4
	evade_cd = 0.5

	fire_cd =  0.6

	projectile_frame = 1
