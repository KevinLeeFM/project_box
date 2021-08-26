extends Spatial

var all_points = {}
var astar = null
onready var grid_map = $GridMap


func _ready():
	astar = AStar.new()
	var cells = grid_map.get_used_cells()
	
