extends CharacterBody2D

@export var max_speed = 80
@export var acceleration = 500
@export var friction = 500
@export var roll_speed = 125

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sword_hit_box = $HitBoxPivot/SwordHitBox
@onready var animationState = animation_tree.get("parameters/playback")
@onready var hurt_box = $hurt_box

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

var motion = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

func _ready():
	stats.connect("no_health", Callable(self, "queue_free"))
	animation_tree.set("parameters/Attack/blend_position", Vector2.DOWN)
	sword_hit_box.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	motion_mode = 1
	var input_vector = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hit_box.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		
		motion = motion.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		motion = motion.move_toward(Vector2.ZERO, friction * delta)
	
	velocity = motion
	move_and_slide()
	motion = velocity
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * roll_speed
	animationState.travel("Roll")
	move_and_slide()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_animation_finished():
	velocity = velocity * 0.6
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_hurt_box_area_entered(area):
	stats.health -= 1
	hurt_box.start_invencibility(0.5)
	hurt_box.create_hit_effect()
