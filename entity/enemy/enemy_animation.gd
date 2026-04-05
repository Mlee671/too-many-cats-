extends AnimationPlayer

var no_interrupt := false

func play_animation(anim_name: StringName):
	if not no_interrupt:
		super.play(anim_name)
