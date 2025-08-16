extends TextureRect
class_name EffectTextureRect

@onready var count: Label = $CenterContainer/PanelContainer/Count
@onready var tip: CanvasItem = $CenterContainer


func set_values(effect: Effect):
	texture = effect.visual.texture
	count.text = effect.get_display_value()
	tip.hide()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	scale = Vector2.ONE * 2
	tip.show()
	z_index += 1


func _on_mouse_exited() -> void:
	scale = Vector2.ONE
	tip.hide()
	z_index -= 1
