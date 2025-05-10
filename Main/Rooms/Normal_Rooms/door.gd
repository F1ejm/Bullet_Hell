extends StaticBody2D

var i 

func _ready() -> void:
	$StaticBody2D.position = Vector2(-236,51)
	



func _on_in_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$StaticBody2D.position = Vector2(0,51)
		Global.IsRoundPlaying = true
		print("zakniete")
