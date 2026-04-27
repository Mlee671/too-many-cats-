extends Projectile
class_name EnemyProjectile


# generally just setter for enemy
func _ready() -> void:
	super()
	knockback = 200
	
