extends CharacterBody3D
signal dieS

const SPEED = 1.0

var canHeat := true
var canMove := true

@onready var target = G.player #get_parent().get_parent().get_parent().find_child("Player")
@onready var targetWeapon = target.find_child("Weapon").get_child(0)
@export var hp = 0
@export var soulCost = 0

enum{
	WALK,
	STAN,
	ATTACK,
}
var state = WALK
var curretState = state

var attackCallwown := false

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	match state:
		WALK:
			move(delta)
		ATTACK:
			attack(target)
			heatReload()
	die()
	
	if state != WALK:
		velocity = Vector3.ZERO
	
	move_and_slide()

func move(delta):
	if canMove:
		if target != null:
			var direction = position.direction_to(target.position) - Vector3(.2,0,.2)
			velocity = SPEED * direction

func damage():
	hp -= targetWeapon.damage
	targetWeapon.find_child("AxeBody").play()
	$Die.play()
	velocity *= 0
	state = STAN
	heatReload()

func die():
	if hp <= 0:
		G.kills += 1
#		$Die.play()
		target.soul_absorption(soulCost)
		dieS.emit()
		queue_free()

func attack(obj):
	if canHeat and target != null:
		var bullet = load("res://Object/Enemy/Bullet.tscn").instantiate()
		canMove = false
		$BulletPos.add_child(bullet)
		canHeat = false
		heatReload()

func heatReload():
	if canHeat == false and attackCallwown == false:
		attackCallwown = true
		$AttackCalldown.start()

func _on_stan_coll_down_timeout() -> void:
	state = curretState

func _on_uron_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		targetWeapon.hit.connect(damage)

func _on_uron_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		targetWeapon.disconnect("hit",damage)
		state = WALK
		curretState = WALK

func _on_ataka_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = ATTACK
		curretState = ATTACK

func _on_ataka_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = WALK
		curretState = WALK



func _on_attack_calldown_timeout() -> void:
	canHeat = true
