extends CharacterBody2D

@export var KNOCKBACK_FORCE: int = 120
@export var KNOCKBACK_FRICTION: int = 200

@export var ACCELERATION: int = 300
@export var MAX_SPEED: int = 50
@export var FRICTION: int = 200
@export var WANDER_TAGER_RANGE: int = 4

@export var GIVE_HP: int = 1
@export var GIVE_EXP: int = 1

const DeathEffect = preload("res://Effects/ButterflyDeathEffect.tscn")

@onready var sprite = $Animate
@onready var stats = $Stats
@onready var playerDection = $PlayerDetection
@onready var hurtBox = $HurtBox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WannderController
@onready var animationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}

var stage = CHASE
func _ready():
	stage = pick_random_stage([IDLE, WANDER])

func _physics_process(delta):
	match stage:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()

		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_toward_point(delta, wanderController.target_position)

			if global_position.distance_to(wanderController.target_position) <= WANDER_TAGER_RANGE:
				update_wander()
				
		CHASE:
			var player = playerDection.player

			if player != null:
				accelerate_toward_point(delta ,player.global_position)
			else:
				stage = IDLE

			sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400 
	move_and_slide()

func update_wander():
	stage = pick_random_stage([IDLE, WANDER])
	wanderController.start_wander_timer(randf_range(1, 3))

func accelerate_toward_point(delta, point):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDection.is_see_player():
		stage = CHASE

func pick_random_stage(stage_list: Array):
	stage_list.shuffle()
	return stage_list.pop_front()

func _on_hurt_box_area_entered(area):
	var direction = (position - area.owner.position).normalized()
	velocity = direction * KNOCKBACK_FORCE
	
	stats.health -= area.damage
	hurtBox.create_hit_effect()
	hurtBox.start_invencibility(0.4)

func _on_stats_die():
	queue_free()
	PlayerStats.EXP += GIVE_EXP
	PlayerStats.health += GIVE_HP

	var deathEffect = DeathEffect.instantiate()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position


func _on_hurt_box_invencible_started():
	animationPlayer.play("Start")


func _on_hurt_box_invencible_ended():
	animationPlayer.play("Stop")
