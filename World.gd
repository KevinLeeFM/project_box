extends Spatial

onready var terrain = $VoxelTerrain
onready var vt = terrain.get_voxel_tool()
const VOXEL_NOT_LOADED_VAL = 255

var indicator_scene = preload("res://tester/AStarVertex.tscn")
var indicators = []

# Called when the node enters the scene tree for the first time.

func _ready():
	yield($VoxelTerrain, "generation_ready") # must be called ahead
	generate_astar_vertices()
	# the game is now ready

func _input(event):
	if event.is_action_pressed("major_action"):
		generate_astar_vertices()

func place_terrain(pos: Vector3):
	vt.do_point(pos)

func generate_astar_vertices():
	
	print('generating voxel')
	
	for i in indicators:
		i.queue_free()
	
	indicators = []
	
#	wait_for_voxel(Vector3(64, 127, 64))
#	wait_for_voxel(Vector3(64, 126, 64))
	
	for x in range(20, 60):
		for z in range(20, 60):
			for y in range(0, 125):
				
		#		wait_for_voxel(Vector3(64, y, 64))
				
				var s0 = vt.get_voxel_f(Vector3(x, y, z))
				var s1 = vt.get_voxel_f(Vector3(x, y + 1, z))
				var s2 = vt.get_voxel_f(Vector3(x, y + 2, z))
				var s3 = vt.get_voxel_f(Vector3(x, y + 3, z))
				var sa1 = vt.get_voxel_f(Vector3(x+1, y + 2, z))
				var sa2 = vt.get_voxel_f(Vector3(x-1, y + 2, z))
				var sa3 = vt.get_voxel_f(Vector3(x, y + 2, z+1))
				var sa4 = vt.get_voxel_f(Vector3(x, y + 2, z-1))
				
				if s1 == VOXEL_NOT_LOADED_VAL:
					print("CRITICAL ERROR: reading blocks that are not loaded!!!")
				
				# ensure that the spot is on a solid ground and there's 
				# 2-block space above it
				if s1 < 0 and abs(s1) < 0.1 and s2 > 0 and s3 > 0.1:
					# ensure that the ground is fairly flat
					if sa1 > 0 and sa2 > 0 and sa3 > 0 and sa4 > 0:
						var indicator = indicator_scene.instance()
						indicator.translation = Vector3(x, y + 2, z)
						add_child(indicator)
						self.indicators.append(indicator)
			
func wait_for_voxel(pos):
	while (vt.get_voxel_f(pos) == VOXEL_NOT_LOADED_VAL):
		pass # wait

func on_terrain_loaded():
	self.generate_astar_vertices()
