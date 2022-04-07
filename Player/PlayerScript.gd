extends Character

export var default_acceleration: float = 10
export var max_default_speed: float = 350

export var default_jump_force: float = 450
export var default_max_jump_count: int = 2

export var gravity : float = 900

var velocity := Vector2.ZERO
var UP := Vector2.UP

var jump_count: int = 2


func _physics_process(delta):
	_handel_movement(delta)
	_handel_wall_detection_direction()
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, UP)


func _handel_movement(delta):
	var dir = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	velocity.x = lerp(velocity.x, max_default_speed * dir, default_acceleration * delta)
	
	# jump ---
	if Input.is_action_just_pressed("jump") and jump_count > 0:
		velocity.y = -default_jump_force
		jump_count -= 1
	
	if ground_detected() and velocity.y > 0:
		jump_count = default_max_jump_count


func _handel_wall_detection_direction():
	var p_direction = int(velocity.normalized().x)
	var CAST_DISTENCE = 12 #PX
	if velocity.x != 0:
		$WallDetector/up.cast_to = Vector2(CAST_DISTENCE, 0) * p_direction
		$WallDetector/down.cast_to = Vector2(CAST_DISTENCE, 0) * p_direction


func ground_detected():
	return $GroundDetector.is_colliding()


func wall_detected():
	return $WallDetector/up.is_colliding() or $WallDetector/down.is_colliding()
