extends Resource
class_name EnemySettings

enum EnemyModification{NONE, GLITCHED}

@export_group("Stats")
@export var health : BaseHealth
@export var start_effects : Array[Effect]
@export var speed : CountBase
@export var reward : CountBase
@export var modification := EnemyModification.NONE
@export_group("Visual")
@export var name := ""
@export var movement_anim: AnimationTextures
@export var death_anim: AnimationTextures
@export var effect_anim: AnimationTextures


func modification_to_string() -> String:
	match modification:
		EnemyModification.NONE:
			return ""
		EnemyModification.GLITCHED:
			return "Glitched"
	printerr("Unexpected value: ", modification)
	return "!Unexpected value"


func get_full_name() -> String:
	return modification_to_string() + name
