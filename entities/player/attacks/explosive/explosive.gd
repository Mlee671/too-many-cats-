extends Node2D
class_name Explosion

@onready var trigger_area := $TriggerBox
@onready var damage_area := $ExplosionRadius

const DAMAGE := 40
const KNOCKBACK := 120
const SPEED := 80

var velocity : Vector2
var rotate_amount := PI / 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	rotate(rotate_amount)


func _on_explosion_trigger(_body: Node2D) -> void:
	velocity = Vector2.ZERO
	rotate_amount = 0
	$AnimationPlayer.play("explode")
	# for each enemy in explosion radius, deal damage
	for target in damage_area.get_overlapping_bodies():
		if target is Enemy:
			target.take_damage(DAMAGE, self, KNOCKBACK)
	# delete self once animation finished
	await $AnimationPlayer.animation_finished
	queue_free()

func set_direction(new_dir: Vector2):
	look_at(new_dir)
	velocity = new_dir.normalized() * SPEED
