@tool
extends Node
class_name Database

const GHOST = preload("res://Resources/Settings/Enemy/ghost.tres")
const GHOSTENTACLE = preload("res://Resources/Settings/Enemy/ghostentacle.tres")
const GHOST_COMB = preload("res://Resources/Settings/Enemy/ghost_comb.tres")
const GHOST_CRAB = preload("res://Resources/Settings/Enemy/ghost_crab.tres")
const GLITCHED_GHOST = preload("res://Resources/Settings/Enemy/glitched_ghost.tres")
const GLITCHED_GHOSTENTACLE = preload("res://Resources/Settings/Enemy/glitched_ghostentacle.tres")
const GLITCHED_GHOST_CRAB = preload("res://Resources/Settings/Enemy/glitched_ghost_crab.tres")

static var enemy_const_dict : Dictionary[String, EnemySettings] = {
	"ghost": GHOST,
	"ghostentacle": GHOSTENTACLE,
	"ghostComb": GHOST_COMB,
	"ghostCrab": GHOST_CRAB,
	"glitchedGhost": GLITCHED_GHOST,
	"glitchedGhostentacle": GLITCHED_GHOSTENTACLE,
	"glitchedGhostCrab": GLITCHED_GHOST_CRAB,
}

static func enemy_json_to_enemy(json_name: String) -> EnemySettings:
	var result := enemy_const_dict[json_name].duplicate(true)
	if result.speed == null:
		printerr(json_name, " -> ", result.get_full_name(), " speed is null")

	return result


static var enemy_array := [
	load("res://Resources/Settings/Enemy/ghost.tres"), 
	load("res://Resources/Settings/Enemy/ghostentacle.tres"), 
	load("res://Resources/Settings/Enemy/ghost_comb.tres"), 
	load("res://Resources/Settings/Enemy/ghost_crab.tres"), 
	load("res://Resources/Settings/Enemy/glitched_ghost.tres"), 
	load("res://Resources/Settings/Enemy/glitched_ghostentacle.tres"), 
	load("res://Resources/Settings/Enemy/glitched_ghost_crab.tres"),
]

static var enemy_dict : Dictionary[String, EnemySettings] = {
	"ghost": load("res://Resources/Settings/Enemy/ghost.tres"),
	"ghostentacle": load("res://Resources/Settings/Enemy/ghostentacle.tres"),
	"ghostComb": load("res://Resources/Settings/Enemy/ghost_comb.tres"),
	"ghostCrab": load("res://Resources/Settings/Enemy/ghost_crab.tres"),
	"glitchedGhost": load("res://Resources/Settings/Enemy/glitched_ghost.tres"),
	"glitchedGhostentacle": load("res://Resources/Settings/Enemy/glitched_ghostentacle.tres"),
	"glitchedGhostCrab": load("res://Resources/Settings/Enemy/glitched_ghost_crab.tres"),
}


static func enemy_name_to_json(game_name: String) -> String:
	for i in enemy_array:
		if i.get_full_name() == game_name:
			return enemy_dict.find_key(i)
	return "!Unexpected"
