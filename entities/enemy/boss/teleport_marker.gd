extends Area2D
class_name TeleportMarker

signal player_found(caller, coords)

func _on_body_entered(body: Node2D) -> void:
	if body is main_character:
		player_found.emit(self, global_position)
		queue_free()
