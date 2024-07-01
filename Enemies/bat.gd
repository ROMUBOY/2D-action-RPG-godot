extends CharacterBody2D

@export var max_speed = 50
@export var acceleration = 300
@export var friction = 200

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hurt_box = $hurt_box
@onready var soft_collision = $SoftCollision
@onready var wander_controller = $WanderController

const enemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

enum{
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wander_controller.get_time_left() <= 0:
				update_wander()
		WANDER:
			seek_player()
			if wander_controller.get_time_left() <= 0:
				update_wander()
			
			acceleration_towards_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= 4:
				update_wander()
		CHASE:
			var player = player_detection_zone.player
			
			if player != null:
				acceleration_towards_point(player.global_position, delta)				
			else:
				state = IDLE
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	move_and_slide()

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(randf_range(1, 3))

func acceleration_towards_point(point, delta):
	var direction =  global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = velocity.x < 0

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurt_box_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 120
	hurt_box.create_hit_effect()

func _on_stats_no_health():
	queue_free()
	var enemyDeathEffectInstance = enemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffectInstance)
	enemyDeathEffectInstance.global_position = global_position
