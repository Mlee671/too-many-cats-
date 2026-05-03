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
	$LifespanTimer.start(10)


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	rotate(rotate_amount)


func _on_explosion_trigger(_body: Node2D) -> void:
	SFX_Manager.play_sound_effect_from_dictionary("explosion_medium")
	velocity = Vector2.ZERO
	rotate_amount = 0
	$AnimationPlayer.play("explode")
	# for each enemy in explosion radius, deal damage
	call_deferred("register_damage")
	# delete self once animation finished
	await $AnimationPlayer.animation_finished
	queue_free()

func register_damage():
	for target in damage_area.get_overlapping_bodies():
		if target is Enemy:
			print("ping")
			target.take_damage(DAMAGE, damage_area, KNOCKBACK)

func set_direction(new_dir: Vector2):
	look_at(new_dir)
	velocity = new_dir.normalized() * SPEED


func _on_lifespan_end() -> void:
	queue_free()
