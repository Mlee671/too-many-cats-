extends Stats

var ability_dur := 1.0

func _ready() -> void:
	speed = 70
	hp = 150
	max_hp = 150

	fire_cd =  0.6

	projectile_frame = 1
	projectile_knockback = 50

	damage = 8
