extends Node2D

@onready var orbitals: Node2D = $Orbitals
@onready var orbital_1: Node2D = $Orbitals/Node2D
@onready var orbital_2: Node2D = $Orbitals/Node2D2
@onready var orbital_3: Node2D = $Orbitals/Node2D3

@onready var orbital_1_area: Area2D = $Orbitals/Node2D/Orbital
@onready var orbital_2_area: Area2D = $Orbitals/Node2D2/Orbital2
@onready var orbital_3_area: Area2D = $Orbitals/Node2D3/Orbital3

func _ready() -> void:
	#orbitale - aktywny itemek
	orbital_1.rotation = 90
	orbital_2.rotation = 180
	orbital_3.rotation = 270


#Orbitale - Pasywny Itemek
func Func_Orbitals(delta):

	orbitals.visible = true
	orbitals.global_rotation += (1.5 * delta) 
		
	for o in orbital_1_area.get_overlapping_areas():
		if o.is_in_group("Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.Death()
	for o in orbital_2_area.get_overlapping_areas():
		if o.is_in_group("Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.Death()
	for o in orbital_3_area.get_overlapping_areas():
		if o.is_in_group("Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.Death()
		
