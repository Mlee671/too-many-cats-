extends Stats


func _ready() -> void:
	speed = 50
	accel = 10 # how smooth stop/start movement
	
	evade_movement_scaling = 2.5
	evade_dur = 0.2
	evade_cd = 0.5

	fire_cd =  0
	
