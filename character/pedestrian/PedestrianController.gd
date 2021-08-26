extends Node

export var character_node_path: NodePath = ".."
export var astar: NodePath = ""

onready var character = get_node(character_node_path)

var destination = null

func _ready():
	pass
		
#	direction = Vector3()

func _physics_process(delta):
	character.walk(Vector3(1, 0, 0))
	character.jump()

func go_to(pos: Vector3):
	self.destination = pos
