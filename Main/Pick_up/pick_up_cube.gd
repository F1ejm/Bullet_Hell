extends StaticBody2D

var label

func _ready():
	label = get_node("/root/Main/CanvasLayer/PowerUP_label")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var x = randi_range(1,12)
		match(x):
			1:
				Global.Dash_PowerUp = true
				label.text = "You Became Unstable Your Dash Now Kills Enemys"
			2:
				Global.Stamina_PowerUp = true
				label.text = "You Became Unstable Your Stamina Is Infinite"
			3:
				Global.Bullet_PowerUp = true
				label.text = "You Became Unstable Your Bullets Pierce Enemy Bullets"
			4:
				Global.Cant_Dash_PowerUp = true
				label.text = "You Became Unstable You Can't Dash"
			5: 
				Global.Cant_Shoot_PowerUp = true
				label.text = "You Became Unstable You Can't Shoot"
			6:
				Global.Move_Slower_PowerUp = true
				label.text = "You Became Unstable You Move Slower"
			_:
				Global.Zycie += randi_range(1,2)
				label.text = "You Became Unstable You Regained Some Health"
		Global.start_powerup_timer = true
		label.visible = true
		queue_free()
