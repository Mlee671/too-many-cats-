extends Stats
class_name bk_stats

func _ready() -> void:
	speed = 100
	accel = 10 # how smooth stop/start movement
	hp = 100
	max_hp = 100
	
	evade_movement_scaling = 1.75
	evade_dur = 0.4
	evade_cd = 0.5

	fire_cd =  .5
	ability_cd = 5

	projectile_frame = 2
