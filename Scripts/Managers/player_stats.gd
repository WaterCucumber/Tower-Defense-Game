extends Node
class_name PlayerStats

var c : Count
static var instance : PlayerStats

@export var level_json_path := "user://Resources/Settings/Levels/level_test.json"

@onready var health_component: HealthComponent = $HealthComponent
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

@onready var money_label: Label = $"../CanvasLayer/UI/Currency/Money/Label"
@onready var health_label: Label = $"../CanvasLayer/UI/Currency/Health/Label"
@onready var camera_2d: Camera2D = $"../Level/Camera2D"

var dev_mode := true

var money := 7.5

var display_money :
	get():
		return max(Math.floor_d(money, 1), 0)

func remove_money(count: float):
	if count < -0.5 and randf() < 0.1:
		health_component.take_damage(self, -1)
		count *= 1.5
	
	money -= count
	update_label(money_label, display_money)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("mute"):
		audio_stream_player.playing = false
	if dev_mode:
		if event.is_action_pressed("money_cheat"):
			money = 999.9
			remove_money(0)
		if event.is_action_pressed("lives_cheat"):
			health_component.can_take_damage = false
			health_component.health.current_health = 999.9
			health_component.take_damage(self, 0)
			CameraShake.add_trauma(20)


func _ready() -> void:
	if dev_mode:
		print_rich("[color=yellow]Caution:[/color] [color=#CFCF01]You are playing with [b]DEVELOPER[/b] mode![/color]")
	instance = self
	
	var waves := GameWaves.new()
	JsonParser.load_resource_from_json(waves, level_json_path)
	money = waves.start_money
	var new_health := Count.new()
	new_health.count = waves.start_health
	#print("new_health: ", new_health.get_count())
	health_component.health.start_health = new_health
	%WaveManager.waves = waves
	
	health_component.initialize()
	health_component.died.connect(on_game_over)
	health_component.took_damage.connect(func(_s, _d): update_label(health_label, health_component.health.display_health))
	update_label(health_label, health_component.health.display_health)
	update_label(money_label, display_money)


func _process(_delta: float) -> void:
	camera_2d.offset = CameraShake.get_offset()


func on_enemy_pass(enemy: Enemy):
	health_component.take_damage(enemy, enemy.health_component.health.current_health)
	CameraShake.add_trauma(20)


func on_game_over():
	print("GG")


func update_label(label: Label, value: float):
	label.text = str(value)
