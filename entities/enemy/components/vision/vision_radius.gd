extends RayCast2D

## Whether the raycast detects target as collidable. It is pre-checked if in
## the Player group
func can_see_player(target: Node2D) -> bool:
	if target == null:
		return false
		
	# weird tilemap init fix, can see through walls frame 0
	if Engine.get_frames_drawn() == 0: 
		return false

	target_position = to_local(target.global_position)
	force_raycast_update()
	if is_colliding():
		return get_collider() == target
	return false
