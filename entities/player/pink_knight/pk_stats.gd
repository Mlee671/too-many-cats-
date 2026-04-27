extends Stats

var ability_dur := 1.0

func _ready() -> void:
	speed = 70
	accel = 10 # how smooth stop/start movement
	hp = 150
	max_hp = 150
	
	evade_dur = 0.4
	evade_cd = 0.5

	fire_cd =  0.6

	projectile_frame = 1
	projectile_knockback = 50

	damage = 8
