extends PathFollow2D
class_name Enemy

signal initialized

@onready var enemy_animation: Node = $EnemyAnimation
@onready var health_component: HealthComponent = $HealthComponent
@onready var enemy_movement: Node = $EnemyMovement
@onready var effect_component: EffectComponent = $EffectComponent

var _settings : EnemySettings
var reached_end := false

func initialize(settings: EnemySettings) -> void:
	_settings = settings.duplicate(true)

	enemy_animation.movement_anim = _settings.movement_anim
	enemy_animation.death_anim = _settings.death_anim
	enemy_animation.effect_anim_tex = _settings.effect_anim
	enemy_animation.initialize()
	
	for i in _settings.start_effects:
		effect_component.set_status(i)
	
	health_component.health = _settings.health
	health_component.initialize()

	if _settings.speed != null:
		enemy_movement.speed = _settings.speed.get_count()
	else:
		print("Speed is null")

	initialized.emit()


func _on_enemy_movement_reached_end() -> void:
	PlayerStats.instance.on_enemy_pass(self)
	reached_end = true
	health_component.died.emit()


func _on_health_component_died() -> void:
	if not reached_end:
		PlayerStats.instance.remove_money(-_settings.reward.get_count())
