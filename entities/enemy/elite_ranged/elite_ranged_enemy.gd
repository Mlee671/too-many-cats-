extends RangedEnemy

const ELITE_SPEED := 50
const ELITE_HP := 200
const ELITE_PROJECTILE_SPEED := 120
const ELITE_APS := 2

# hard overwrites consts in regular enemy
func _ready() -> void:
	SPEED = ELITE_SPEED
	HP = ELITE_HP
	PROJECTILE_SPEED = ELITE_PROJECTILE_SPEED
	ATTACKS_PER_SECOND = ELITE_APS
	super()
