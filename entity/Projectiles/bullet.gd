extends Area2D
class_name bullet

var velocity : Vector2
var speed := 200

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position += velocity * delta

# is called when its colliding with a collision box
func _on_body_entered(body: Node2D) -> void:
	if body is not main_character:
		# deletes itself
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
