extends Area2D
class_name MeleeAttack

var damage := 1000
var already_attacked := []

func set_damage(new_damage: int):
	damage = new_damage

func deal_damage() -> int:
	return damage

func reset():
	already_attacked.clear()

func _on_enemy_in_range(enemy: Node2D) -> void:
	if enemy is Enemy:
		if enemy in already_attacked:
			return
		enemy.take_damage(damage, self, 160)
		already_attacked.append(enemy)
