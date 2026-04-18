extends Stats


func _ready() -> void:
	speed = 50
	accel = 10 # how smooth stop/start movement
	hp = 100
	
	evade_dur = 0.4
	evade_cd = 0.5

	fire_cd =  0
	
