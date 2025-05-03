extends Control

@onready var label: Label = $Label

func _process(delta: float) -> void:
	label.text = str(Global.VDolce)
