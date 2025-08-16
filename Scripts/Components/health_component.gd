extends Node2D
class_name HealthComponent

signal died
signal took_damage(source: Object, damage)

@export var health : BaseHealth

var already_died := false
var can_take_damage := true

func initialize():
	health.initialize()


func take_damage(source: Object, damage):
	if not can_take_damage:
		took_damage.emit(source, 0)
		return
	took_damage.emit(source, health.take_damage(source, damage))

	if not (health.alive or already_died):
		already_died = true
		died.emit()
