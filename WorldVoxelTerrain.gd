extends VoxelTerrain


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var load_count = 0
var vt = self.get_voxel_tool()

signal generation_ready

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("block_loaded", self, "block_counter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
	
	
	# hacky, but works I guess
#	if vt.get_voxel_f(Vector3(64, 64, 64)) != 255 and self.get_statistics()["remaining_main_thread_blocks"] == 0:
#		print('ready' + str(vt.get_voxel_f(Vector3(64, 64, 64))))
#		emit_signal("generation_ready")

# Each block is a 16 x 16 x 16 voxel chunk
# If counter == (world volume) / 16^3, that means everything is loaded
func block_counter(pos):
	self.load_count += 1

	if load_count == self.bounds.get_area() / pow(self.mesh_block_size, 3):
		emit_signal("generation_ready")
