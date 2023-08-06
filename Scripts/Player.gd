extends CharacterBody3D

const SPEED := 2.0
const FRICTION := 5.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp := 100
var soulCount := 0
var power := 100
var canMove := true
var final := false

var canReloadEnergy = false

var magicCount = []

@onready var animatedSprite: AnimatedSprite3D = $AnimatedSprite3D

#animation
var AnimSide = "Forward"
var AnimState = "Idle"

func _physics_process(delta: float) -> void:
	hp = clamp(hp, 0, 100)
	power = clamp(power, 0, 100)
	soulCount = clamp(soulCount, 0, 100)
#	print(hp)
	
	move(delta)
	gravitation(delta)
	die()
	resurrection()
	animation()
	create_magic()
	reload_energy()
	
	move_and_slide()

func create_magic():
	if Input.is_action_just_pressed("magic") and magicCount.size() < 1 and power >= 100:
		canReloadEnergy = false
		power -= 100
		var magic = load("res://Object/Weapon/BulletPlayer.tscn").instantiate()
		$MagicPosition.add_child(magic)
		magicCount.append(magic)
		$MagicCalldown.start()

func gravitation(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func move(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
#	print(direction)
#	print(velocity.z)
	
	if canMove:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			if direction.x > 0:
				animatedSprite.set_flip_h(true)
				$Weapon.scale.x = 1
			elif direction.x < 0:
				animatedSprite.set_flip_h(false)
				$Weapon.scale.x = -1
		else:
			velocity = lerp(velocity, Vector3.ZERO, FRICTION * delta)

func die() -> void:
	if hp == 0:
#		print("YA UMER")
		animatedSprite.modulate = Color(1, 1, 1, .25)
		final = true
	elif hp > 0:
		animatedSprite.modulate = Color(1, 1, 1, 1)
		final = false

func soul_absorption(cost):
	if final:
		soulCount += cost

func resurrection():
	if final and soulCount == 100:
		hp = 100
		soulCount = 0
		final = false

func okonchatelno_die():
	queue_free()
	var game_over = preload("res://Object/UI/game_over.tscn").instantiate()
	G.canvas.add_child(game_over)

func animation():
	#forward
	if velocity.z > 1:
		AnimSide = "Forward"
		AnimState = "Walk"
		animatedSprite.play(AnimState + AnimSide)
	elif velocity.z > .1:
		AnimSide = "Forward"
		AnimState = "Idle"
		animatedSprite.play(AnimState + AnimSide)
	
	#back
	if velocity.z < -1:
		AnimSide = "Back"
		AnimState = "Walk"
		animatedSprite.play(AnimState + AnimSide)
	elif velocity.z < -.1:
		AnimSide = "Back"
		AnimState = "Idle"
		animatedSprite.play(AnimState + AnimSide)
	
	#x coordianate
	if velocity.x > .1 or velocity.x < -.1:
		AnimState = "Walk"
		animatedSprite.play(AnimState + AnimSide)

func reload_energy():
	if canReloadEnergy and magicCount.size() < 1:
		power += 1
		if power == 100:
			canReloadEnergy = false

func _on_magic_calldown_timeout() -> void:
		canReloadEnergy = true
