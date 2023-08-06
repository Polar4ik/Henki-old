extends CharacterBody3D

@onready var target = G.player #get_parent().get_parent().get_parent().get_parent().get_parent().find_child("Player")
@onready var targetWeapon = target.find_child("Weapon").get_child(0)
var damage := 50

func _physics_process(delta: float) -> void:
	if target != null:
		var direction = position.direction_to(target.position)
		velocity = 1 * direction
		look_at(target.position)
	
	move_and_slide()

func _on_kamikadze_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		$Shell.hide()
		$GPUParticles3D.hide()
		if body.final:
			body.okonchatelno_die()
		else:
			body.hp -= damage
		queue_free()

func _on_unichtozhit_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		targetWeapon.hit.connect(func(): 
			$Shell.hide()
			$GPUParticles3D.hide()
			queue_free())
