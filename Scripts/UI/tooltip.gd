extends Control
class_name ControlTooltip

const OFFSET_Y := Vector2.DOWN * 30
const OFFSET_X := Vector2.RIGHT * 20

@onready var rich_text_label: RichTextLabel = %TooltipText

var opacity_tween : Tween = null

func set_text_of_tooltip(text: String):
	rich_text_label.text = text
	update_size()

func update_size():
	# Обновляем размер PanelContainer в зависимости от размера RichTextLabel
	var new_size = rich_text_label.get_combined_minimum_size()
	size = new_size + Vector2(20, 20) # Добавляем отступы
	queue_redraw() # Перерисовать, если необходимо


func _ready(): hide()


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		var pos = get_global_mouse_position() + size.x/2 * Vector2.RIGHT + OFFSET_Y + OFFSET_X
		var control_rect = Rect2(pos, size)
		var viewport_rect = get_viewport().get_visible_rect()
		
		# Если Tooltip выходит за правую границу, показываем слева
		if control_rect.position.x + control_rect.size.x > viewport_rect.position.x + viewport_rect.size.x:
			pos.x = get_global_mouse_position().x - size.x - OFFSET_X.x
		# Если выходит за нижнюю границу, сдвигаем вверх
		if control_rect.position.y + control_rect.size.y > viewport_rect.position.y + viewport_rect.size.y:
			pos.y = get_global_mouse_position().y - size.y
		
		global_position = pos


func is_control_fully_visible() -> bool:
	var control_rect := get_global_rect()
	var viewport_rect := get_viewport().get_visible_rect()
	
	# Проверяем, что viewport_rect полностью содержит control_rect
	return viewport_rect.encloses(control_rect)


func toggle(on: bool):
	if on:
		show()
		modulate.a = 0
		tween_opacity(1)
	else:
		modulate.a = 1
		await tween_opacity(0).finished
		hide()


func tween_opacity(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.15)
	return opacity_tween
