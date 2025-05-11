extends StaticBody2D

var i 


func _ready() -> void:
	$StaticBody2D.position = Vector2(-236,51)
	



func _on_in_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Global.IsRoundPlaying == false:
		Global.IsRoundPlaying = true
		Global.Czas_Rundy = 60
		Global.Pierwszy_Pokój = true
		get_parent().is_Player_in_room = true
		$StaticBody2D.position = Vector2(0,51)
		$"../../Spawner".active=true
