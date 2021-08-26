extends RayCast

onready var hover_select_indicator = $Despatialize/HoverSelectIndicator
onready var debug_label = $DebugLabel

var collider: Object = null
var collision_point: Vector3 = Vector3()
var hover_select: Vector3 = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	self.collider = self.get_collider()
	self.collision_point = self.get_collision_point()
	
	if collider != null:
		self.hover_select = collision_point.floor()
		self.hover_select_indicator.set_visible(true)
		self.hover_select_indicator.translation = self.hover_select + Vector3(0.5, 0.5, 0.5)
		
		if collider.get_class() == "VoxelTerrain":
			var vt = collider.get_voxel_tool()
			self.debug_label.set_text("Voxel data: " + str(vt.get_voxel_f(self.hover_select)) + " Coordinate: " + str(hover_select))
	else:
		self.hover_select_indicator.set_visible(false)

func _input(event):
	
	# Place object only if it is a terrain
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event.is_action_pressed("major_action"):
			self.erase_terrain()
		elif event.is_action_pressed("minor_action"):
			self.place_terrain()
	
	# TODO: remove later
	if Input.is_key_pressed(KEY_F):
		get_tree().get_root().find_node("Pedestrian")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func place_terrain():
	collider = self.get_collider()
	collision_point = self.get_collision_point()
	
	print(collision_point)
	print(collider)
	
	# place terrain
	if collider != null and collider.get_class() == "VoxelTerrain":
		var vt = collider.get_voxel_tool()
		
		vt.set_mode(VoxelTool.MODE_ADD)
		vt.do_sphere(self.hover_select, 2)

func erase_terrain():
	collider = self.get_collider()
	collision_point = self.get_collision_point()
	
	# place terrain
	if collider != null and collider.get_class() == "VoxelTerrain":
		var vt = collider.get_voxel_tool()
		
		vt.set_mode(VoxelTool.MODE_REMOVE)
		vt.do_point(self.hover_select)
