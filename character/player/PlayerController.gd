extends Node

var mouse_sensitivity = 2
var joystick_deadzone = 0.2

export var character_node_path: NodePath = ".."
export var head_node_path: NodePath = "../Head"

onready var character = get_node(character_node_path)
onready var head = get_node(head_node_path)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Look with the mouse
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		character.rotation_degrees.y -= event.relative.x * mouse_sensitivity / 18
		head.rotation_degrees.z -= event.relative.y * mouse_sensitivity / 18
		head.rotation_degrees.z = clamp(head.rotation_degrees.z, -90, 90)
		
	if event.is_action_pressed("escape_mouse_capture"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event.is_action_pressed("major_action"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
#	direction = Vector3()

func _physics_process(delta):
	# Direction inputs
	var direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction.x += 1
	if Input.is_action_pressed("move_backward"):
		direction.x += -1
	if Input.is_action_pressed("move_leftward"):
		direction.z += 1
	if Input.is_action_pressed("move_rightward"):
		direction.z += -1
		
	character.walk(direction)
	
	if Input.is_action_pressed("jump"):
		character.jump()
	
	# walk only when player is holding walk mode
	character.set_walking(Input.is_action_pressed("move_mode_walk"))
	
	# crouch only when player is holding crouch mode
	character.set_crouching(Input.is_action_pressed("move_mode_crouch"))
