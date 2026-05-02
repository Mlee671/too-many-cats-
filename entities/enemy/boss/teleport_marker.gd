extends Area2D

signal player_found(coords)

func _on_body_entered(body: Node2D) -> void:
	if body is main_character:
		player_found.emit(global_position)
		queue_free()
