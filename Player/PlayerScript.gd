extends Character

export var default_acceleration: float = 10
export var max_default_speed: float = 350

export var gravity : float = 900

var velocity := Vector2.ZERO
var UP := Vector2.UP

func _physics_process(delta):
	_handel_movement(delta)
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, UP)


func _handel_movement(delta):
	var dir = int(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	velocity.x = lerp(velocity.x, max_default_speed * dir, default_acceleration * delta)
