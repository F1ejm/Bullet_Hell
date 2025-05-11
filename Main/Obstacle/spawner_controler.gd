extends NavigationRegion2D


func _on_timer_timeout() -> void:
	bake_navigation_polygon()


func _on_template_controler_nic() -> void:
	bake_navigation_polygon()
