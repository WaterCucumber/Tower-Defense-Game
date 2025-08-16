extends ColorRect
class_name EnemyUI

const EFFECT_TEXTURE_RECT := preload("res://Scenes/UI/effect_texture_rect.tscn")

static var picked_enemy : EnemyUI

@export var always_show := true

@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var label: Label = $VBoxContainer/Label
@onready var status_effects: HBoxContainer = $VBoxContainer/VBoxContainer/StatusEffects
@onready var other_effects: HBoxContainer = $VBoxContainer/VBoxContainer/OtherEffects

var is_mouse_on := false
var start_effects : Array[Effect]

func initialize() -> void:
	update_health()
	start_effects.append_array(owner._settings.health.health_effects)
	update_effect_visual(status_effects, start_effects)
	if not always_show: hide()


func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT 
			and event.is_pressed() and is_mouse_on):
		if picked_enemy: 
			picked_enemy.scale = Vector2.ONE
			if not always_show: picked_enemy.visible = picked_enemy.is_mouse_on
			picked_enemy.z_index -= 1
			if picked_enemy == self: 
				#print("Unpicked enemy: ", picked_enemy.owner.name)
				picked_enemy = null
				return
		picked_enemy = self
		scale = Vector2.ONE * 1.5
		z_index += 1
		#print("Picked enemy: ", picked_enemy.owner.name)
		if not always_show: show()


func _on_health_component_took_damage(_source: Object, _damage: Variant) -> void:
	update_health()


func update_health():
	var health := health_component.health
	label.text = str(health.display_health) + "/" + str(health.display_max_health)
	health_bar.value = health.current_health / health.max_health


func _on_enemy_initialized() -> void:
	initialize()


func _on_mouse_area_mouse_entered() -> void:
	if not always_show: show()
	is_mouse_on = true


func _on_mouse_area_mouse_exited() -> void:
	is_mouse_on = false
	if picked_enemy == self: return
	if not always_show: hide()


func _on_effect_component_status_updated(effects: Array[Effect]) -> void:
	update_effect_visual(other_effects, effects)


func update_effect_visual(container: HBoxContainer, effects: Array[Effect]):
	for child in container.get_children():
		child.queue_free()
	
	for effect in effects:
		var effect_texture_rect := EFFECT_TEXTURE_RECT.instantiate()

		if effect is DurationEffect: effects.erase(effect)

		container.add_child(effect_texture_rect)
		effect_texture_rect.set_values(effect)
