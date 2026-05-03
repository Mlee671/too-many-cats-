extends Projectile
class_name EnemyProjectile


# generally just setter for enemy
func _ready() -> void:
	super()
	knockback = 200
	$UnwallTimer.start(0.5)

func _on_unwall() -> void:
	collision_mask = 3 # players and walls
