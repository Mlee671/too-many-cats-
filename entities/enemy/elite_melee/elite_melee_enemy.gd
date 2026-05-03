extends BasicMeleeEnemy
class_name EliteMeleeEnemy

const ELITE_SPEED := 75.0
const ELITE_HP := 150
const ELITE_WEIGHT := 2
const ELITE_VISION := 120.0
const ELITE_ATTACK_DUR := 0.3
const ELITE_APS := 2.5

func _ready() -> void:
	SPEED = ELITE_SPEED
	HP = ELITE_HP
	WEIGHT = ELITE_WEIGHT
	ATTACK_DURATION = ELITE_ATTACK_DUR
	ATTACKS_PER_SECOND = ELITE_APS
	VISION = ELITE_VISION
	super()
