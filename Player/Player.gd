extends CharacterBody2D

@onready var ui: Control = $CanvasLayer/UI

func _ready() -> void:
	ui.visible = false

func _physics_process(delta):
	if Global.stop == true:
		return
	
	look_at(get_global_mouse_position())
	
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * Global.speed

	move_and_slide()
