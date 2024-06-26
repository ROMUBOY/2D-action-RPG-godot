extends CharacterBody2D

@export var max_speed = 80
@export var acceleration = 500
@export var friction = 500
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animationState = animation_tree.get("parameters/playback")

var motion = Vector2.ZERO

func _physics_process(delta):
	motion_mode = 1
	var input_vector = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		
		motion = motion.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		motion = motion.move_toward(Vector2.ZERO, friction * delta)
	
	velocity = motion
	move_and_slide()
	motion = velocity
