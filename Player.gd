extends CharacterBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80
const ROLL_SPEED = 100

enum {
	MOVE,
	ROLL,
	ATTACK
}

var stage = MOVE
var roll_vector = Vector2.LEFT
var stats = PlayerStats

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationStage = animationTree.get("parameters/playback")
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var hurtBox = $HurtBox
@onready var hurtBoxCollision = $HurtBox/CollisionShape2D

func _ready():
	randomize()
	animationTree.active = true
	stats.connect("die", queue_free)

func _physics_process(delta):
	match stage:
		MOVE:
			move_stage(delta)
		ROLL:
			roll_stage(delta)
		ATTACK:
			attack_stage()

func move_stage(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		
		animationStage.travel("Run")
		
		roll_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationStage.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

	if Input.is_action_just_pressed("roll"):
		if PlayerStats.stamina > 0:
			PlayerStats.stamina -= 1
			stage = ROLL

	if Input.is_action_just_pressed("attack"):
		if PlayerStats.stamina > 0:
			PlayerStats.stamina -= 1
			stage = ATTACK
	
func roll_stage(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationStage.travel("Roll")
	move_and_slide()

func attack_stage():
	velocity = Vector2.ZERO
	animationStage.travel("Attack")

func animaion_ended():
	stage = MOVE
	velocity = velocity / 3
	hurtBoxCollision.disabled = false

func _on_hurt_box_area_entered(area):
	stats.health -= area.damage
	print("ATTACK:", stats.health)
	
	hurtBox.start_invencibility(0.6)
	hurtBox.create_hit_effect()
	
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_hurt_box_invencible_started():
	blinkAnimationPlayer.play("Start")

func _on_hurt_box_invencible_ended():
	blinkAnimationPlayer.play("Stop")
