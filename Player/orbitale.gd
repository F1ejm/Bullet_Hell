extends Node2D

@onready var orbitals: Node2D = $Orbitals
@onready var orbital_1: Node2D = $Orbitals/Node2D
@onready var orbital_2: Node2D = $Orbitals/Node2D2
@onready var orbital_3: Node2D = $Orbitals/Node2D3

@onready var orbital_1_area: Area2D = $Orbitals/Node2D/Orbital
@onready var orbital_2_area: Area2D = $Orbitals/Node2D2/Orbital2
@onready var orbital_3_area: Area2D = $Orbitals/Node2D3/Orbital3

func _ready() -> void:
	var orbit2 = $Orbitals/Node2D2/Orbital2/AnimatedSprite2D
	var orbit3 = $Orbitals/Node2D3/Orbital3/AnimatedSprite2D
	#orbitale - aktywny itemek
	orbital_1.rotation = 90
	orbital_2.rotation = 180
	orbital_3.rotation = 270
	$Orbitals/Node2D/Orbital/AnimatedSprite2D.play("default")
	orbit2.play("default")
	orbit2.frame = 2
	orbit3.play("default")
	orbit3.frame = 4

#Orbitale - Pasywny Itemek
func Func_Orbitals(delta):

	orbitals.visible = true
	orbitals.global_rotation += (1.5 * delta) 

func _on_orbital_area_entered(o: Area2D) -> void:
	if orbitals.visible == true:
		if o.is_in_group("Bullet") or o.is_in_group("Boss_Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.health -= 3
		if o.is_in_group("Boss") and o.can_be_hit == true:
			o.health -= 1

func _on_orbital_2_area_entered(o: Area2D) -> void:
	if orbitals.visible == true:
		if o.is_in_group("Bullet") or o.is_in_group("Boss_Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.health -= 3
		if o.is_in_group("Boss") and o.can_be_hit == true:
			o.health -= 1

func _on_orbital_3_area_entered(o: Area2D) -> void:
	if orbitals.visible == true:
		if o.is_in_group("Bullet") or o.is_in_group("Boss_Bullet"):
			o.queue_free()
		if o.is_in_group("Enemy"):
			o.owner.health -= 3
		if o.is_in_group("Boss") and o.can_be_hit == true:
			o.health -= 1
