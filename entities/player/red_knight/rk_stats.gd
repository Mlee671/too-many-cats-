extends Stats
class_name rk_state

func _ready() -> void:
	speed = 100
	accel = 10 # how smooth stop/start movement
	hp = 100
	
	evade_movement_scaling = 1.75
	evade_dur = 0.4
	evade_cd = 0.5

	fire_cd =  0.1
	ability_cd = 1
	
	projectile_frame = 1
	projectile_speed = 250
	projectile_knockback = 20
	
	damage = 5
