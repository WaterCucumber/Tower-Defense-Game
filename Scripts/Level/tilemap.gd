extends Node2D

@onready var grass_layer: TileMapLayer = $GrassLayer
@onready var rock_layer: TileMapLayer = $RockLayer
@onready var water_layer: TileMapLayer = $WaterLayer
@onready var lava_layer: TileMapLayer = $LavaLayer
@onready var path_layer: TileMapLayer = $PathLayer
@onready var buff_layer: TileMapLayer = $BuffLayer
@onready var other_layers: TileMapLayer = $OtherLayers


func _ready() -> void:
	var build_manager : BuildManager = BuildManager.instance
	if not build_manager: return
	
	build_manager.grass_layer = grass_layer
	build_manager.rock_layer = rock_layer
	build_manager.water_layer = water_layer
	build_manager.lava_layer = lava_layer
	build_manager.path_layer = path_layer
	build_manager.buff_layer = buff_layer
