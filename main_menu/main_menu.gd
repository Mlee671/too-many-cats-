extends Control
@export var controls_image: TextureRect
@export var background_image: TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#changes scene to main when start button pressed
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_controls_button_pressed() -> void:
	controls_image.visible = true
	
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_mouse_click(event: InputEvent) -> void:
	if event.is_action_pressed("fire_gun"):
		controls_image.visible = false
