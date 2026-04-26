extends Control
@export var controls_image: TextureRect
@export var background_image: TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#plays the fade in transition which will then change scene to main
func _on_start_button_pressed() -> void:
	
	$fade_transition.show()
	$fade_transition/fade_transition_timer.start()
	$fade_transition/AnimationPlayer.play("fade_in")

func _on_controls_button_pressed() -> void:
	controls_image.visible = true
	
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

#removes the controls image when you left click anywhere
func _on_mouse_click(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		controls_image.visible = false

#when you finish fading in, loads and switches to main
func _on_fade_transition_timer_timeout() -> void:
	
	
	
	var scene : PackedScene = load("res://main/main.tscn")
	
	await get_tree().create_timer(1.2).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_packed(scene)
	
	
