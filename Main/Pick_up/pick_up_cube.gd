extends StaticBody2D

var Player: CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var x = randi_range(1,4)
		match(x):
			1:
				Player.Dash_PowerUp = true
				print("NI")
			2:
				Player.Stamina_PowerUp = true
				print("GG")
			3:
				Player.Bullet_PowerUp = true
				print("E")
			4:
				Player.Cant_Dash_PowerUp = true
				print("R")
		Player.power_up_timer.start()
		queue_free()
