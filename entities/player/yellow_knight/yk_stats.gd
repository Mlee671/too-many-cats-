extends Stats

var ability_dur := 5.0

func _ready() -> void:
	speed = 50
	hp = 150
	max_hp = 150

	fire_cd =  0.6

	projectile_frame = 1
