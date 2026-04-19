extends Projectile
class_name PlayerProjectile

@onready var sprite = $Sprite
var proj_frame := 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame = proj_frame
	knockback = 80
	super._ready()
