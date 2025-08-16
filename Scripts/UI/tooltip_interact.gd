extends Control
class_name TooltipInteract

@onready var tooltip: ControlTooltip = $Tooltip

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_text_of_tooltip(text: String) -> void:
	tooltip.set_text_of_tooltip(text)


func _on_mouse_entered():
	tooltip.toggle(true)


func _on_mouse_exited():
	tooltip.toggle(false)
