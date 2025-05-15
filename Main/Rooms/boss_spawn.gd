extends Area2D

var boss1_path = preload("res://Enemy/bossowie/boss_1.tscn")
var boss2_path = preload("res://Enemy/bossowie/boss_2.tscn")
var boss3_path = preload("res://Enemy/bossowie/boss_3.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		AudioManager.play_boss_music(-30)
		randomize()
		var rand = randi_range(1,2)
		if rand == 11:
			var boss = boss1_path.instantiate()
			$"..".add_child(boss)
			boss.global_position = $Node2D.global_position
			boss.Player = get_node("/root/Main/Player")
			boss.main = get_node("/root/Main")
		if rand == 21:
			var boss = boss2_path.instantiate()
			$"..".add_child(boss)
			boss.global_position = $Node2D.global_position
			boss.Player = get_node("/root/Main/Player")
			boss.main = get_node("/root/Main")
		if rand == 1 or rand == 3 or rand == 2:
			var boss = boss3_path.instantiate()
			$"..".add_child(boss)
			boss.global_position = $Node2D.global_position
			boss.Player = get_node("/root/Main/Player")
			boss.main = get_node("/root/Main")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var get_out = $"../Get_Out"
		var get_out_collision = $"../Get_Out/CollisionShape2D"
		var anim_player = $"../AnimationPlayer"

		if get_out and get_out_collision:
			get_out.visible = true
			get_out_collision.visible = true
		if anim_player:
			anim_player.play("close")

		queue_free()
