extends NavigationRegion2D


func _ready() -> void:
	bake_navigation_polygon()

func _on_timer_timeout() -> void:
	bake_navigation_polygon()
