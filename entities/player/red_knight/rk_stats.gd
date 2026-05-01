extends Stats
class_name rk_state

func _ready() -> void:
	speed = 100
	hp = 100
	

	fire_cd =  0.1
	ability_cd = 1
	
	projectile_frame = 1
	projectile_speed = 250
	projectile_knockback = 20
	
	damage = 5
