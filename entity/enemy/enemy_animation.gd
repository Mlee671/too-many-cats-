extends AnimationPlayer

var no_interrupt := false

func play_animation(name: StringName):
	if not no_interrupt:
		super.play(name)
