extends Node
class_name BuildManager

const GRASS_TILE = preload("res://Assets/Sprites/Turrets/UI/grass_tile.png")
const LAVA_TILE = preload("res://Assets/Sprites/Turrets/UI/lava_tile.png")
const PATH_TILE = preload("res://Assets/Sprites/Turrets/UI/path_tile.png")
const ROCK_TILE = preload("res://Assets/Sprites/Turrets/UI/rock_tile.png")
const WATER_TILE = preload("res://Assets/Sprites/Turrets/UI/water_tile.png")
const NONE_TILE = preload("res://Assets/Sprites/Turrets/UI/none_tile.png")

enum TileType {NONE, GRASS, ROCK, WATER, LAVA, PATH}
enum TileEffectType {
	NONE, ## Empty
	# Good
	RADIUS, ## Opposite - BLIND
	FIRE_RATE, ## Opposite - SLOWNESS
	DISCOUNTED, ## Opposite - OVERPRICED
	DAMAGE, ## Opposite - WEAKNESS
	# Bad
	BLIND, ## Opposite - RADIUS
	SLOWNESS, ## Opposite - FIRE_RATE
	OVERPRICED, ## Opposite - DISCOUNTED
	WEAKNESS, ## Opposite - DAMAGE
	}

static var instance

@export var grass_layer : TileMapLayer
@export var rock_layer : TileMapLayer
@export var water_layer : TileMapLayer
@export var lava_layer : TileMapLayer
@export var path_layer : TileMapLayer
@export var buff_layer : TileMapLayer

var can_place_tower := true
var tiles_with_turret : Array[Vector2i]

var tile_effect_dict: Dictionary[Vector2i, TileEffectType] = {
	Vector2i(0, 2): TileEffectType.FIRE_RATE,
	Vector2i(1, 2): TileEffectType.DAMAGE,
	Vector2i(2, 2): TileEffectType.RADIUS,
	Vector2i(3, 2): TileEffectType.DISCOUNTED,

	Vector2i(0, 3): TileEffectType.SLOWNESS,
	Vector2i(1, 3): TileEffectType.WEAKNESS,
	Vector2i(2, 3): TileEffectType.BLIND,
	Vector2i(3, 3): TileEffectType.OVERPRICED,
}

var tile_dict: Dictionary[TileType, Texture2D] = {
	TileType.NONE : NONE_TILE,
	TileType.GRASS : GRASS_TILE,
	TileType.ROCK : ROCK_TILE,
	TileType.WATER : WATER_TILE,
	TileType.LAVA : LAVA_TILE,
	TileType.PATH : PATH_TILE
}

func get_tile_at_global_position(pos: Vector2) -> LevelTileData:
	var map_pos := grass_layer.local_to_map(grass_layer.to_local(pos))
	var result := LevelTileData.new()
	result.map_position = map_pos
	result.global_position = pos

	if has_tile(grass_layer, map_pos):
		result.type = TileType.GRASS
	elif has_tile(rock_layer, map_pos):
		result.type =  TileType.ROCK
	elif has_tile(water_layer, map_pos):
		result.type =  TileType.WATER
	elif has_tile(lava_layer, map_pos):
		result.type =  TileType.LAVA
	elif has_tile(path_layer, map_pos):
		result.type =  TileType.PATH
	else:
		result.type =  TileType.NONE

	if has_tile(buff_layer, map_pos):
		var atlas_coords := buff_layer.get_cell_atlas_coords(map_pos)
		result.buff = tile_effect_dict.get(atlas_coords, TileEffectType.NONE)
		if result.buff == TileEffectType.NONE:
			printerr("Can't match atlas coords: ", atlas_coords, " wtih values in dictionary!")

	return result


func has_tile(tile_map_layer: TileMapLayer, map_pos: Vector2i) -> bool:
	return tile_map_layer.get_cell_source_id(map_pos) != -1


func _ready() -> void:
	instance = self


class LevelTileData:
	var type := TileType.NONE
	var buff := TileEffectType.NONE
	var map_position := Vector2i.ZERO
	var global_position := Vector2.ZERO

	func _to_string() -> String:
		return "{map_pos=" + str(map_position) + ", global_pos=" + str(global_position) + ", type=" + TileType.keys()[type] + ", buff=" + TileEffectType.keys()[buff] +"}"
