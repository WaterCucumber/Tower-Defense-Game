extends ProgressBar

@export var damage_visual_time := 1.0
@onready var damage_bar: ProgressBar = $DamageBar

var previous_value := 1.0
var time := 0.0


func _process(delta: float) -> void:
	if value != previous_value:
		if time >= damage_visual_time:
			time = 0
			damage_bar.value = value
			previous_value = value
			return
		else:
			time += delta
		damage_bar.value = lerp(previous_value, value, time / damage_visual_time)


func _on_value_changed(_current_value: float) -> void:
	time = 0
	previous_value = damage_bar.value
