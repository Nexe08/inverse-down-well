extends Character

export var default_acceleration: float = 10
export var max_default_speed: float = 350

export var default_jump_force: float = 450
export var wall_jump_force: Vector2 = Vector2(500, 300)
export var default_max_jump_count: int = 2

export var default_wall_slide_speed: float = 50

export var gravity : float = 900

var velocity := Vector2.ZERO
var UP := Vector2.UP

var jump_count: int = 2


func _physics_process(delta):
	_handel_movement(delta)
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, UP)


func _handel_movement(delta):
	var dir = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	velocity.x = lerp(velocity.x, max_default_speed * dir, default_acceleration * delta)
	
	# jump ---
	if Input.is_action_just_pressed("jump"): 
		if not ground_detected():
			if left_wall_detected() or right_wall_detected(): # wall jump ---
				
				if left_wall_detected():
					velocity.x = wall_jump_force.x
				if right_wall_detected():
					velocity.x = -wall_jump_force.x
					
				velocity.y = -wall_jump_force.y
				jump_count = default_max_jump_count
		else:
			if jump_count > 0:
				velocity.y = -default_jump_force
				jump_count -= 1
	
	if (ground_detected() and velocity.y > 0):
		jump_count = default_max_jump_count
	
	if velocity.y > 0:
		if left_wall_detected() and Input.is_action_pressed("move_left"):
			velocity.y = clamp(velocity.y, 0, default_wall_slide_speed)
		elif right_wall_detected() and Input.is_action_pressed("move_right"):
			velocity.y = clamp(velocity.y, 0, default_wall_slide_speed)



# world detector ---
func ground_detected():
	return $GroundDetector.is_colliding()


func left_wall_detected():
	return $WallDetector/Left/up.is_colliding() or \
		$WallDetector/Left/down.is_colliding()


func right_wall_detected():
	return $WallDetector/Right/up.is_colliding() or \
		$WallDetector/Right/down.is_colliding()
