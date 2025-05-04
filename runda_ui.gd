extends Control

@onready var runda: Label = $Runda
@onready var czas: Label = $Czas

func _process(delta: float) -> void:
	runda.text = str(Global.Runda)
	czas.text = str(int(Global.Czas_Rundy)) + "s"
