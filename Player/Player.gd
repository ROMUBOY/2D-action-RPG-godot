extends CharacterBody2D

@export var max_speed = 80
@export var acceleration = 500
@export var friction = 500

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)	
	
	move_and_slide()
