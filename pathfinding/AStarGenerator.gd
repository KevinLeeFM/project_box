extends Node

var indicator_scene = preload("res://tester/AStarVertex.tscn")

onready var astar: AStar = AStar.new()
var indicators = []
var highest_id: int = 0

# maps a hashed Vector3 position to its point ID, if there is one
# pos is prior to adding 0.5

var hashed_pos_to_point = {}

# TODO: should not hardcode this
var box_size = Vector3(128, 128, 128)

# this is dependent on the implementation of VoxelTool
const VOXEL_NOT_LOADED_VAL = 255

func generate_astar_vertices(vt: VoxelTool):
	
	print('generating vertices')
	
	clean_up()
	
	for x in range(20, 60):
		for z in range(20, 60):
			for y in range(0, 125):
				
#				var s0 = vt.get_voxel_f(Vector3(x, y, z))
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
						add_vertex(Vector3(x, y + 2, z))
						
	print(astar.get_point_path(409, 410))

func clean_up():
	for i in indicators:
		i.queue_free()
	
	indicators = []
	
	astar.clear()
	highest_id = 0
	
	hashed_pos_to_point = {}

# pos is prior to adding 0.5
func add_vertex(pos: Vector3):
	var indicator = indicator_scene.instance()
	indicator.translation = pos + Vector3(0.5, 0.5, 0.5)
	add_child(indicator)
	self.indicators.append(indicator)
	
	highest_id += 1
	astar.add_point(highest_id, pos + Vector3(0.5, 0.5, 0.5))
	hashed_pos_to_point[hash_pos(pos)] = highest_id
	
	connect_neighbours(highest_id, pos)

# pos is prior to adding 0.5
func connect_neighbours(id: int, pos: Vector3):
	for dx in [-1, 0, 1]:
		for dz in [-1, 0, 1]:
			# don't want to connect oneself
			if dx == 0 and dz == 0:
				continue
			
			var neighid = get_point_by_pos(pos + Vector3(dx, 0, dz))
			
			if neighid != null:
				# admittedly this will have redundant operations
				astar.connect_points(id, neighid, true)
#				print("connecting " + str(id) + " to " + str(neighid))

# pos is prior to adding 0.5
# returns the ID
# if no point at pos, return null
func get_point_by_pos(pos):
	
	var hashed = hash_pos(pos)
	
	if not (hashed in hashed_pos_to_point):
		return null
	
	return hashed_pos_to_point[hashed]

# hashes vector into an integer that can be used as key value in posint_point_hash
func hash_pos(pos: Vector3):
	assert(pos < box_size)

	return pos.x * box_size.y * box_size.z + pos.y * box_size.z + pos.z

## dehashes integer into a vector from hash_pos
## TODO: we do not know yet whether this actually works!!!
#func dehash_pos(hashed: int):
#	assert(hashed < box_size.x * box_size.y * box_size.z)
#
#	# note that integer divisions truncates decimal values
#	return Vector3(hashed / (box_size.y * box_size.z), (hashed / box_size.z) % box_size.y, hashed % box_size.z)
