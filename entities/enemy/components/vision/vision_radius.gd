extends RayCast2D

var target: main_character
var vision_range: float

func can_see_player() -> bool:
	# weird tilemap init fix, can see through walls frame 0
	if Engine.get_frames_drawn() == 0: 
		return false
		
	var distance = global_position.distance_squared_to(target.global_position)
	if distance > vision_range* vision_range:
		return false
	target_position = to_local(target.global_position)
	force_raycast_update()
	if is_colliding():
		return get_collider() == target
	return false
