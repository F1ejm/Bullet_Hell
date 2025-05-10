extends CanvasLayer

# żeby właczyć przejście przed wczytaniem nowej sceny trzeba napisać:
# Transition.transition()
# await Transition.on_transition_finished

signal on_transition_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_3: ColorRect = $ColorRect3
@onready var color_rect_4: ColorRect = $ColorRect4

func _ready() -> void:
	color_rect.visible = false
	color_rect_3.visible = false
	color_rect_4.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_in":
		on_transition_finished.emit()
		animation_player.play("fade_out")
	elif anim_name == "fade_out":
		color_rect.visible = false
		color_rect_3.visible = false
		color_rect_4.visible = false

func transition():
	color_rect.visible = true
	color_rect_3.visible = true
	color_rect_4.visible = true
	animation_player.play("fade_in")
