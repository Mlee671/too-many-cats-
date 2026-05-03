extends AudioStreamPlayer2D
class_name Audio_Stream_Player_2D

@export var audio_library = Audio_library.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func play_sound_effect_from_dictionary(_tag: String)->void:
	if _tag:
		var audio_stream = audio_library.get_audio_stream(_tag)
		if !playing: self.play()
		
		var  audio_stream_playback := self.get_stream_playback()
		audio_stream_playback.play_stream(audio_stream)
	else:
		printerr("no tag provided")
