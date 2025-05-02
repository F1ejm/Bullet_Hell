extends CharacterBody2D


func _physics_process(delta):
	if Global.stop == true:
		return
	
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * Global.speed

	move_and_slide()
