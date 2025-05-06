extends StaticBody2D

var Player: CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var x = randi_range(1,6)
		match(x):
			1:
				Player.Dash_PowerUp = true
				print("1")
			2:
				Player.Stamina_PowerUp = true
				print("2")
			3:
				Player.Bullet_PowerUp = true
				print("3")
			4:
				Player.Cant_Dash_PowerUp = true
				print("4")
			5: 
				Player.Cant_Shoot_PowerUp = true
				print("5")
			6:
				Player.Move_Slower_PowerUp = true
				print("6")
		Player.power_up_timer.start()
		queue_free()
