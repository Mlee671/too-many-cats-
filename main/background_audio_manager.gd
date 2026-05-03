extends Node2D

@onready var rand_index = randi()%get_child_count()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_child(rand_index).playing = true	
	pass # Replace with function body.

func _process(delta: float) -> void:
	position = $"../character_manager".get_child(0).position

func _on_audio_stream_player_2d_finished() -> void:
	var new_rand_index = randi()%get_child_count()
	while new_rand_index == rand_index:
		if new_rand_index == rand_index:
			new_rand_index = randi()%get_child_count()
	get_child(new_rand_index).playing = true
	rand_index = new_rand_index
	pass # Replace with function body.
