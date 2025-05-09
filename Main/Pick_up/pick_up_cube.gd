extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var x = randi_range(1,6)
		match(x):
			1:
				Global.Dash_PowerUp = true
				print("1")
			2:
				Global.Stamina_PowerUp = true
				print("2")
			3:
				Global.Bullet_PowerUp = true
				print("3")
			4:
				Global.Cant_Dash_PowerUp = true
				print("4")
			5: 
				Global.Cant_Shoot_PowerUp = true
				print("5")
			6:
				Global.Move_Slower_PowerUp = true
				print("6")
		Global.start_powerup_timer = true
		queue_free()
