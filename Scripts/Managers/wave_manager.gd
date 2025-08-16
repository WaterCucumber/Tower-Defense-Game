extends Node
class_name WaveManager

signal all_enemies_died

const ENEMY = preload("res://Scenes/Objects/enemy.tscn")

static var instance: WaveManager

@export var all_enemies : Array[EnemySettings]
@export var spawn_wave := false
@export var path_spawner: PathSpawner

@onready var ready_button: Button = $"../../CanvasLayer/UI/ReadyButton"

var wave_index := 0
var waves: GameWaves

var writing := false
var code := ""
var spawn_i := 0
var break_loops := false

var enemies_alive := 0


func _ready() -> void:
	instance = self
	if not spawn_wave:
		ready_button.hide()


func _unhandled_key_input(event: InputEvent) -> void:
	if PlayerStats.instance.dev_mode and event is InputEventKey:
		if event.is_action_pressed("spawn_enemy"):
			writing = !writing
			if not writing:
				spawn_enemy_by_code(code)
			else:
				print("-Spawn code")
				code = ""
			return
		elif event.is_pressed() and writing:
			#print("Key pressed: ", OS.get_keycode_string(event.keycode))
			if event.unicode != 0:
				code += char(event.unicode)
				print("--Code: ", code)


# _code = "3?5:0.5" (index?count:spawn_cooldown (in seconds))
func spawn_enemy_by_code(_code: String):
	if _code == "b":
		break_loops = !break_loops
		print("---Spawn abillity set to ", !break_loops, "!")
		return
	if _code == "w":
		ready_button.show()
		spawn_wave = false
		print("---Stopped wave running (enemies from wave may still spawning). Showed ready button")
		return

	var index := _code.split("?")[0]
	_code = _code.erase(0, (index + "?").length())
	if index.is_valid_int() and int(index) >= 0 and all_enemies.size() > int(index):
		var spawn_format_dict := {"i": index}
		var enemy := all_enemies[int(index)]
		var spawn_count := _code.split(":")[0]
		_code = _code.erase(0, (spawn_count + ":").length())
		if spawn_count.is_valid_int() and int(spawn_count) > 0:
			spawn_format_dict["c"] = spawn_count

			var spawn_cooldown := _code
			if spawn_count.is_valid_float() and float(spawn_cooldown) >= 0.05:
				spawn_awaited_enemies(enemy, int(spawn_count), float(spawn_cooldown))
				spawn_format_dict["s"] = spawn_cooldown
				print("---Spawn: ", code, ". " +
						"Three (max) arguments: index ({i}), count ({c}), spawn cooldown ({s})".format(
								spawn_format_dict))
			else:
				spawn_awaited_enemies(enemy, int(spawn_count))
				print("---Spawn: ", code, ". Two arguments: index ({i}), count ({c}); spawn cooldown = 1".format(
						spawn_format_dict))
		else:
			initialize_enemy(ENEMY, enemy)
			print("---Spawn: ", code, ". One argument: index ({i}); count = 1".format(
					spawn_format_dict))
	else:
		print("--*Unsuccessfull: ", code, ". Can't get index or index is too large! (max index: ", all_enemies.size() - 1, ") Use: 0?2:2")


func spawn_awaited_enemies(enemy: EnemySettings, count: int, spawn_cooldown : float = 1):
	var start_spawn_i := 0
	if break_loops: return
	while break_loops or start_spawn_i < count:
		await get_tree().create_timer(spawn_cooldown).timeout
		initialize_enemy(ENEMY, enemy)
		start_spawn_i += 1


func initialize_enemy(enemy_scene: PackedScene, enemy: EnemySettings):
	var temp_enemy : Enemy = enemy_scene.instantiate()
	temp_enemy.name = "*" + enemy.modification_to_string() + "?" + enemy.name + "#" + str(spawn_i) + "t" + str(Time.get_ticks_msec())
	path_spawner.path.add_child(temp_enemy)
	temp_enemy.initialize(enemy)
	spawn_i += 1
	enemies_alive += 1
	temp_enemy.health_component.died.connect(on_enemy_died)


func spawn_current_wave(wave: Wave):
	for i in wave.components:
		if not spawn_wave: return
		await spawn_awaited_enemies(i.enemy, i.count, i.spawn_cooldown)
		if i.await_time_after >= 0.05: 
			await get_tree().create_timer(i.await_time_after).timeout


func start_spawn_waves(): 
	while spawn_wave and wave_index < waves.waves.size():
		await spawn_current_wave(waves.waves[wave_index])
		await all_enemies_died
		wave_index += 1
		await get_tree().create_timer(2).timeout
	if spawn_wave: print("You won!")


func on_enemy_died():
	enemies_alive -= 1
	if enemies_alive <= 0:
		all_enemies_died.emit()


func _on_ready_button_pressed() -> void:
	start_spawn_waves()
	ready_button.hide()
