extends Stats


func _ready() -> void:
	speed = 50
	accel = 10 # how smooth stop/start movement
	hp = 200
	max_hp = 200
	
	evade_dur = 0.4
	evade_cd = 0.5

	fire_cd =  0.8
	ability_cd = 5
	
