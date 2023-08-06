extends CharacterBody3D
signal dieS

const SPEED = 1.0

var canHeat := false

@onready var target = G.player #get_parent().get_parent().get_parent().find_child("Player")
@onready var targetWeapon = target.find_child("Weapon").get_child(0)
@export var hp = 0
@export var damage = 0
@export var soulCost = 0

enum{
	WALK,
	STAN,
	ATTACK,
}
var state = WALK
var curretState = state

var attackCallwown := false

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
	if target != null:
		var direction = position.direction_to(target.position)
		velocity = SPEED * direction

func stan():
	hp -= targetWeapon.damage
	targetWeapon.find_child("AxeBody").play()
	velocity *= 0
	state = STAN
	heatReload()

func die():
	if hp <= 0:
		$AnimatedSprite3D.hide()
		$Die.play()
		G.kills += 1
		target.soul_absorption(soulCost)
		dieS.emit()
		queue_free()

func attack(obj):
	if canHeat and target != null:
		if obj.hp > 0:
			obj.hp -= damage
		else:
			obj.okonchatelno_die()
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
		targetWeapon.hit.connect(stan)

func _on_uron_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		targetWeapon.disconnect("hit",stan)
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
