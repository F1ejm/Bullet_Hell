extends Node2D

@onready var piorun: Area2D = $Piorun

func _on_timer_timeout() -> void:
	Cast_Piorun()
	
func Cast_Piorun():
	var x = randi_range(-100, 100)
	var y = randi_range(-100,100)
	
	piorun.position = Vector2(x,y)
	
	for o in piorun.get_overlapping_areas():
		if o.is_in_group("Enemy"):
			o.owner.Death
