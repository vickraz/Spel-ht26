extends CanvasLayer

var time: float = 0.0
var player_alive: bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_alive:
		time += delta #Tiden i sekunder
		
		var min = int(time/60)
		var sec = int(time - min*60)
		var time_string = "%02d:%02d" % [min, sec]
		$TimeLabel.text = "Time: " + time_string
	

#Anropas av level då spelaren dör
func update_heart_symbols(lives: int) -> void:
	var hearts_to_hide = 3 - lives
	var i = 0
	for heart_sybmol in $HBoxContainer.get_children():
		if i < hearts_to_hide:
			heart_sybmol.hide()
			i += 1
		else:
			break
