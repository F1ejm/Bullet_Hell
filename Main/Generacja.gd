extends Node2D

@onready var navigation_obstacle_2d: NavigationObstacle2D = $NavigationRegion2D/NavigationObstacle2D
@onready var sprite_2d: Sprite2D = $NavigationRegion2D/NavigationObstacle2D/Sprite2D
@onready var navigation_obstacle_2d_2: NavigationObstacle2D = $NavigationRegion2D/NavigationObstacle2D2
@onready var sprite_2d_2: Sprite2D = $NavigationRegion2D/NavigationObstacle2D2/Sprite2D
@onready var sprite_2d_3: Sprite2D = $NavigationRegion2D/NavigationObstacle2D3/Sprite2D
@onready var navigation_obstacle_2d_3: NavigationObstacle2D = $NavigationRegion2D/NavigationObstacle2D3

var Lista: Array = [navigation_obstacle_2d,navigation_obstacle_2d_2,navigation_obstacle_2d_3]
var Sprite: Array = [sprite_2d,sprite_2d_2,sprite_2d_3]

var sciana: NavigationObstacle2D = navigation_obstacle_2d
var sprite: Sprite2D

var rand = 1

func Generate_Lista():
	sciana = Lista[rand]

func Generate_Sprite():
	sprite = Sprite[rand]
	
func _process(delta: float) -> void:
	if Global.Generate_wall == true:
		Global.Generate_wall = false
		rand = randi_range(0,len(Lista)-1)
		Generate_Lista()
		Generate_Sprite()
		sciana.affect_navigation_mesh = true
		sprite.visible = true
		$NavigationRegion2D.bake_navigation_polygon()
