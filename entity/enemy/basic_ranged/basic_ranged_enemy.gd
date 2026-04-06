extends Enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 30.0
	accel = 20.0
	pathfind_range = 6
	health.set_health(100)
	super._ready()
