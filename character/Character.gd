extends KinematicBody

var controller = null

var run_speed = 6 # Running speed in m/s
var walk_speed = run_speed / 2
var crouch_speed = run_speed / 3
var jump_height = 6

var current_speed = run_speed

var ground_acceleration = 10
var air_acceleration = 5
var acceleration = air_acceleration

var direction = Vector3()
var velocity = Vector3() # Direction with acceleration added
var movement = Vector3() # Velocity with gravity added

var gravity = 12 # was 9.8
var gravity_vec = Vector3()

var snapped = false
var can_jump = true
var intend_jump = false
var walking = false
var crouching = false
var can_crouch = true

# Data:
var player_speed = 0
var falling_velocity = 0

func walk(dir):
	dir = dir.normalized()
	# Rotates the direction from the Y axis to move forward
	self.direction = dir.rotated(Vector3.UP, rotation.y)
	
func jump():
	intend_jump = true
	
func set_walking(val: bool):
	self.walking = val
	
func set_crouching(val: bool):
	self.crouching = val

func _physics_process(delta):
	
	# Snaps the character on the ground and changes the gravity vector to climb
	# slopes at the same speed until 45 degrees
	if is_on_floor():
		if snapped == false:
			falling_velocity = gravity_vec.y
#			land_animation()
		acceleration = ground_acceleration
		movement.y = 0
		gravity_vec = -get_floor_normal() * 10
		snapped = true
	else:
		acceleration = air_acceleration
		if snapped:
			gravity_vec = Vector3()
			snapped = false
		else:
			gravity_vec += Vector3.DOWN * gravity * delta
	
	if is_on_floor():
		if walking:
			current_speed = walk_speed
		elif crouching:
			current_speed = crouch_speed
		else:
			current_speed = run_speed
			
	if intend_jump:
		intend_jump = false
		if is_on_floor() and can_jump:
			snapped = false
			can_jump = false
			gravity_vec = Vector3.UP * jump_height
	else:
		can_jump = true
	
	if is_on_ceiling():
		gravity_vec.y = 0
	
	velocity = velocity.linear_interpolate(direction * current_speed, acceleration * delta)
	
	movement.x = velocity.x + gravity_vec.x
	movement.z = velocity.z + gravity_vec.z
	movement.y = gravity_vec.y
	
	movement = move_and_slide(movement, Vector3.UP, true)
	
	player_speed = movement.length()

#func land_animation():
#	var movement_y = clamp(falling_velocity, -20, 0) / 40
#
#	$LandTween.interpolate_property($Head/Camera, "translation:y", 0, movement_y, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
#	$LandTween.interpolate_property($Head/Camera, "translation:y", movement_y, 0, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.1)
#	$LandTween.start()
#
#func crouch_animation(button_pressed):
#	if button_pressed:
#		if not crouching:
#			$CrouchTween.interpolate_property($MeshInstance, "mesh:mid_height", $MeshInstance.mesh.mid_height, 0.25, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			$CrouchTween.interpolate_property($CollisionShape, "shape:height", $CollisionShape.shape.height, 0.25, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			$CrouchTween.interpolate_property($Head, "translation:y", $Head.translation.y, 1.35, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			$CrouchTween.start()
#			crouching = true
#	else:
#		if crouching:
#			$CrouchTween.interpolate_property($MeshInstance, "mesh:mid_height", $MeshInstance.mesh.mid_height, 0.75, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			$CrouchTween.interpolate_property($CollisionShape, "shape:height", $CollisionShape.shape.height, 0.75, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			$CrouchTween.interpolate_property($Head, "translation:y", $Head.translation.y, 1.6, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#			$CrouchTween.start()
#			crouching = false
