extends CharacterBody2D

@export var max_speed = 100
@export var acceleration = 10
@export var friction = 10

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector.normalized() * acceleration * delta
		velocity = velocity.limit_length(max_speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)	
	
	move_and_collide(velocity)
