extends CharacterBody2D


var speed = 600  


func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * speed

	move_and_slide()
