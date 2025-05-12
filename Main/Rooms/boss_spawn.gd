extends Area2D

var boss1_path = preload("res://Enemy/bossowie/boss_1.tscn")
var boss2_path = preload("res://Enemy/bossowie/boss_2.tscn")
var boss3_path = preload("res://Enemy/bossowie/boss_3.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		randomize()
		var rand = randi_range(1,3)
		if rand == 15:
			var boss = boss1_path.instantiate()
			$"..".add_child(boss)
			boss.global_position = $Node2D.global_position
			boss.Player = get_node("/root/Main/Player")
			boss.main = get_node("/root/Main")
		if rand == 4:
			var boss = boss2_path.instantiate()
			$"..".add_child(boss)
			boss.global_position = $Node2D.global_position
			boss.Player = get_node("/root/Main/Player")
			boss.main = get_node("/root/Main")
		if rand == 3 or rand == 1 or rand == 2:
			var boss = boss3_path.instantiate()
			$"..".add_child(boss)
			boss.global_position = $Node2D.global_position
			boss.Player = get_node("/root/Main/Player")
			boss.main = get_node("/root/Main")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#$"../Get_Out".visible = true
#		$"../Get_Out/CollisionShape2D".visible = true
#		$"../AnimationPlayer".play("close")
		queue_free()
