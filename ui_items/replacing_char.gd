extends CanvasLayer
@onready var rep_first_slot: TextureButton = $Control/rep_first_slot
@onready var rep_second_slot: TextureButton = $Control/rep_second_slot
@onready var rep_third_slot: TextureButton = $Control/rep_third_slot

var menu_icons = []
var menu_path = "res://ui_assets/character_menu_sprite/"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_slot_icons(nodes):
	var icons = []
	
	for i in nodes:
		
		icons.append(load(menu_path + i.name+"_menu.png"))
	
	rep_first_slot.texture_normal = icons[0]
	rep_second_slot.texture_normal = icons[1]
	rep_third_slot.texture_normal = icons[2]
