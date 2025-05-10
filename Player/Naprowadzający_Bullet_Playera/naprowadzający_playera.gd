extends Area2D

var speed = 150
var enemy: Area2D

var dmg: int


func _physics_process(delta: float) -> void:
	if enemy != null:
		look_at(enemy.global_position)
		global_position += ((global_position - $Pivot.global_position) * delta * speed)
	else:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		area.owner.health -= dmg
		queue_free()
	if area.is_in_group("Boss") and area.can_be_hit == true:
		area.health -= 5
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Wall"):
		queue_free()
