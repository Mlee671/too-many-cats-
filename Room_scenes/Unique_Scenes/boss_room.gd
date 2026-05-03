extends Node2D
class_name Boss_room

const SOUTH_DOOR_CLOSED := [Vector2i(6,6),Vector2i(7,6)]
const NS_DOOR_OPEN := [Vector2i(7,5),Vector2i(8,5)]

var enemy_list : Array = []
var locked := false

@onready var door_south := $South_door
@onready var room := $Tilemaps/Room
@onready var objects := $Tilemaps/Environment
@onready var boss := $BossEnemy

func _ready() -> void:
	enemy_list.append(boss)
	boss.rotation = 0 - rotation
	
# only mask on player layer
func _on_room_activator_body_entered(body: Node2D) -> void:
	if not locked and body is main_character and enemy_list:
		locked = true
		for enemy in enemy_list:
			enemy.activate_enemy()
			
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

func enemy_died(_enemy : Enemy):
	locked = false
	enemy_list = []
	get_tree().get_first_node_in_group("main").game_won()
