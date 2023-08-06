extends Control

func _process(delta: float) -> void:
	if G.player != null:
		$HPBar.value = move_toward($HPBar.value, G.player.hp, delta * 200)
		$EnergyBar.value = move_toward($EnergyBar.value, G.player.power, delta * 200)
		$SoulBar.value = move_toward($SoulBar.value, G.player.soulCount, delta * 200)
		$KillsLabel.text = "KILLS" + " " + str(G.kills)
		if G.player.final:
			$HPBar.hide()
			$SoulBar.show()
		else :
			$HPBar.show()
			$SoulBar.hide()
	
	await get_tree().create_timer(5).timeout
	$Help.modulate = lerp($Help.modulate, Color(1 , 1, 1, 0), delta * 2)
	$Location.modulate = lerp($Help.modulate, Color(1 , 1, 1, 0), delta * 2)
