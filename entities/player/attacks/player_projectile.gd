extends Projectile
class_name PlayerProjectile

@onready var sprite = $Sprite
var proj_frame := 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	sprite.frame = proj_frame
	super._ready()
	

func set_knockback(scalar: int):
	knockback = scalar
