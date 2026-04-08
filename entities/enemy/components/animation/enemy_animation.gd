extends AnimationPlayer

var no_interrupt := false

func play_animation(anim_name: StringName):
	if not no_interrupt:
		super.play(anim_name)


func _on_animation_finished(anim_name: StringName) -> void:
	no_interrupt = false
