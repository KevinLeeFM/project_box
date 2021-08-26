extends Spatial

onready var terrain = $VoxelTerrain
onready var vt = terrain.get_voxel_tool()
onready var astar_generator = $AStarGenerator

# Called when the node enters the scene tree for the first time.

func _ready():
	yield($VoxelTerrain, "generation_ready") # must be called ahead
	astar_generator.generate_astar_vertices(vt)
	# the game is now ready

func _input(event):
	# TODO remove later
	if Input.is_action_just_pressed("debug_reset_astar"):
		astar_generator.generate_astar_vertices(vt)

func place_terrain(pos: Vector3):
	vt.do_point(pos)
