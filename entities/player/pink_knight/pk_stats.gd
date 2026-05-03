extends Stats



func _ready() -> void:
	speed = 85
	hp = 150
	max_hp = 150
	ability_dur = 2
	ability_cd = 6
	fire_cd =  0.6

	projectile_frame = 1
	projectile_knockback = 50

	damage = 16
