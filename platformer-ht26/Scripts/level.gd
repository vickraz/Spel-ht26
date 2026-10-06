extends Node2D


const PLAYER_SCENE = preload("res://Scenes/player.tscn")

@onready var player: Player = $Player
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos
@onready var camera_2d: Camera2D = $Camera2D
@onready var heart: Area2D = $Heart

var player_lives: int = 3

@export var level_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.get_node("RemoteTransform2D").remote_path = camera_2d.get_path()
	player.connect("dead", _on_player_dead)
	heart.connect("pickup", _on_heart_pickup)
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.connect("activated", _on_checkpoint_activated)
	



func _on_checkpoint_activated(pos: Vector2, node_name: String) -> void:
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		if checkpoint.name != node_name:
			checkpoint.deactivate()
	
	player_spawn_pos.global_position = pos
	

func _on_player_dead() -> void:
	player_lives -= 1
	$HUD.update_heart_symbols(player_lives)
	if player_lives > 0:
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
