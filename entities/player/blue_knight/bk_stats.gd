extends Stats
class_name bk_stats

func _ready() -> void:
	speed = 100
	hp = 100
	max_hp = 100

	fire_cd =  0.5
	ability_cd = 5
	
	# which bullet sprite to use
	projectile_frame = 2
	projectile_speed = 400
	projectile_knockback = 5
	
	damage = 20
