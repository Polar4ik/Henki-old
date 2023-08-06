extends Node3D
signal hit

@export var damage := 15
@export var energy_count := 20
var can_beat := true
var can_reload := false

var rng = RandomNumberGenerator.new()
var audioList = ["res://Assets/Sound/Axe/bd3c834119f353b.mp3", "res://Assets/Sound/Axe/fb5b527adcfa08b.mp3"]
var audioListPointer

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	attack()
	reload()
#	print(can_reload)

func attack():
	if Input.is_action_just_pressed("impact") and can_beat and G.player.power > 0:
		$AnimationPlayer.play("Attack")
		can_beat = false
		can_reload = false
		if G.player.final == false:
			G.player.power -= energy_count
			$EnergyReload.set_wait_time(3)
			$EnergyReload.start()
		hit.emit()
		
		if !$AxeBody.is_playing():
			audio_standart_play()
		
		$CollDown.start()
		G.player.canMove = false
		G.player.velocity = Vector3.ZERO
		await $CollDown.timeout
		G.player.canMove = true

func audio_standart_play():
	audioListPointer = rng.randi_range(0,1)
	$AxeImpact.stream = load(audioList[audioListPointer])
	$AxeImpact.play()

func reload():
	if can_reload:
		G.player.power += 1
		if G.player.power == 100:
			can_reload = false

func _on_reload_timeout() -> void:
	can_beat = true

func _on_energy_reload_timeout() -> void:
	can_reload = true
