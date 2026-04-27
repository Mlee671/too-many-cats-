extends Node2D
class_name Base_room

const WEST_DOOR := [Vector2i(7,4),Vector2i(7,5)]
const EAST_DOOR := [Vector2i(8,4),Vector2i(8,5)]
const NORTH_DOOR_CLOSED := [Vector2i(6,3),Vector2i(7,3)]
const SOUTH_DOOR_CLOSED := [Vector2i(6,6),Vector2i(7,6)]
const NS_DOOR_OPEN := [Vector2i(7,5),Vector2i(8,5)]

var enemy_list : Array = []
var locked := false

@onready var door_west := $West_door
@onready var door_east := $East_door
@onready var door_north := $North_door
@onready var door_south := $South_door
@onready var objects := $Tilemaps/Environment

func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			var parent = get_parent()
			if parent is Room_manager:
				var new_enemy = parent.get_enemy().instantiate()
				new_enemy.position = child.position
				enemy_list.append(new_enemy)
				add_child(new_enemy)
				child.queue_free()

func enemy_died():
	for i in range(enemy_list.size() - 1, -1, -1):
			if enemy_list[i]:
				enemy_list.remove_at(i)
	if !enemy_list:
		locked = false
		
func _physics_process(_delta: float) -> void:
	# keypress check for toggling door locks
	if Input.is_action_just_pressed("debug_lock_doors"):
		locked = !locked

func _on_west_door_body_entered(body: Node2D) -> void:
	if body is main_character and !locked:
		var doorway := [Vector2i(-10,-1), Vector2i(-10,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,WEST_DOOR[i],1)

func _on_west_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-10,-1), Vector2i(-10,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,WEST_DOOR[i],0)

func _on_east_door_body_entered(body: Node2D) -> void:
	if body is main_character and !locked:
		var doorway := [Vector2i(9,-1), Vector2i(9,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,EAST_DOOR[i],1)

func _on_east_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(9,-1), Vector2i(9,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,EAST_DOOR[i],0)

func _on_north_door_body_entered(body: Node2D) -> void:
	if body is main_character and !locked:
		var doorway := [Vector2i(-1,-10), Vector2i(0,-10)]
		for i in 2:
			objects.set_cell(doorway[i],0,NS_DOOR_OPEN[i],0)

func _on_north_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-1,-10), Vector2i(0,-10)]
		for i in 2:
			objects.set_cell(doorway[i],0,NORTH_DOOR_CLOSED[i],0)

func _on_south_door_body_entered(body: Node2D) -> void:
	if body is main_character and !locked:
		var doorway := [Vector2i(-1,9), Vector2i(0,9)]
		for i in 2:
			objects.set_cell(doorway[i],0,NS_DOOR_OPEN[i],0)

func _on_south_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-1,9), Vector2i(0,9)]
		for i in 2:
			objects.set_cell(doorway[i],0,SOUTH_DOOR_CLOSED[i],0)

# only mask on player layer
func _on_room_activator_body_entered(body: Node2D) -> void:
	if body is main_character:
		locked = true
		for enemy in enemy_list:
			enemy.activate_enemy()


func _on_room_activator_body_exited(body: Node2D) -> void:
	if body is main_character:
		locked = false
		for enemy in enemy_list:
			enemy.deactivate_enemy()
