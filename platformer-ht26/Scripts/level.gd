extends Node2D

const SAVE_FILE_PATH = "user://platformerHT26_savefile.data"

const MAX_LEVEL = 2
const PLAYER_SCENE = preload("res://Scenes/player.tscn")

@onready var player: Player = $Player
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos
@onready var camera_2d: Camera2D = $Camera2D
@onready var heart: Area2D = $Heart



@export var level_number: int

var highscores: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.get_node("RemoteTransform2D").remote_path = camera_2d.get_path()
	player.connect("dead", _on_player_dead)
	heart.connect("pickup", _on_heart_pickup)
	$HUD.update_heart_symbols(Global.lives)
	$VictoryMenu.connect("change_level", _change_level)
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.connect("activated", _on_checkpoint_activated)
	
	_get_highscores()
	if name in highscores: #Nuvarande level har ett sparat highscore
		pass #Visa highscore som text mha HUD
		
	



func _on_checkpoint_activated(pos: Vector2, node_name: String) -> void:
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		if checkpoint.name != node_name:
			checkpoint.deactivate()
	
	player_spawn_pos.global_position = pos
	

func _on_player_dead() -> void:
	Global.lives -= 1
	$HUD.update_heart_symbols(Global.lives)
	if Global.lives > 0:
		player = PLAYER_SCENE.instantiate()
		player.connect("dead", _on_player_dead)
		player.global_position = player_spawn_pos.global_position
		player.get_node("RemoteTransform2D").remote_path = camera_2d.get_path()
		add_child(player)
	else:
		$HUD.player_alive = false
		$GameOverMenu.show()


func _on_heart_pickup() -> void:
	player.set_physics_process(false) #Spelaren kan ej röra sig längre
	player.anim.active = false #Stänga av animationer
	$HUD.set_process(false)
	$VictoryMenu.show()
	
	#Kontroll om highscore -> spara nytt highscore


func _change_level() -> void:
	var next_level = level_number + 1
	var level_path = "res://Scenes/Levels/level_" + str(next_level) + ".tscn"
	if next_level <= MAX_LEVEL:
		get_tree().change_scene_to_file(level_path)
	else:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")


func _get_highscores() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		highscores = file.get_var()
		file.close()


func _save_highcores(level_name: String, time: float) -> void:
	highscores[level_name] = time
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(highscores)
	file.close()
		
