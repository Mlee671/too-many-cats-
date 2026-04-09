extends AnimationPlayer

var no_interrupt := false

func play_animation(anim_name: StringName, lock: bool = false):
	if no_interrupt and is_playing(): 
		return
	super.play(anim_name)
	if lock:
		no_interrupt = true


func _on_animation_finished(_anim_name: StringName) -> void:
	no_interrupt = false
