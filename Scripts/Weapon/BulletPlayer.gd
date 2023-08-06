extends CharacterBody3D

var target: Vector3

var damage := 100

var mouse_position

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("magic"):
		mouse_position = get_viewport().get_mouse_position()
		target = Vector3(ray().x, .5, ray().z)
		
func _physics_process(delta: float) -> void:
	var direction = position.direction_to(target)
	velocity = 2 * direction
	
	move_and_slide()

func ray():
	var camera = get_tree().root.get_camera_3d()
	var spaceState = get_world_3d().direct_space_state
	
	var rayOrigin = camera.project_ray_origin(mouse_position)
	
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	
	var intersaction = spaceState.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
	
	if intersaction.has("position"):
		return intersaction["position"]
	return Vector3()


func _on_kamikadze_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		if body.is_in_group("Bullet"):
			$Shell.hide()
			$GPUParticles3D.hide()
			body.queue_free()
			G.player.magicCount.clear()
			queue_free()
		else:
			body.hp -= 100
			$Shell.hide()
			$GPUParticles3D.hide()
			G.player.magicCount.clear()
			queue_free()
