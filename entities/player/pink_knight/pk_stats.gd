extends Stats



func _ready() -> void:
	speed = 70
	hp = 150
	max_hp = 150
	ability_dur = 0
	ability_cd = 5
	fire_cd =  0.6

	projectile_frame = 1
	projectile_knockback = 50
	attack_sfx = "sword_light"
	damage = 8
