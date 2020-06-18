extends Node2D

const BOUNDS := Rect2(512, 300, 1024, 600)
const SPAWN_DISTANCE := Globals.PIG_SPAWN_DIST

const PIG_COLOURS := [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1)]

const happy_pig_res := preload("res://HappyPig.tscn")
const angry_pig_res := preload("res://AngryPig.tscn")

onready var player: Player = $Player

var angry_pig_chance := 0.2


func _ready():
    $SpawnTimer.connect("timeout", self, "_on_timer_timeout")
    

func _on_timer_timeout():
    spawn_pig()


func spawn_pig():
    var angle := find_spawn_angle()
    var pig = happy_pig_res.instance() if randf() > angry_pig_chance else angry_pig_res.instance()
    pig.position = get_spawn_position(player.position, angle)
    pig.rotation = angle + rand_range(-PI/3, PI/3)
    pig.colour = get_random_colour()
    pig.player = player
    add_child(pig)    
    

func find_spawn_angle() -> float:
    while true:
        var angle = rand_range(0, 2*PI)
        var point = get_spawn_position(player.position, angle)
        if BOUNDS.has_point(point):
            return angle
    return 0.0  # Required to keep type checker happy


func get_spawn_position(player_position: Vector2, angle: float):
    return player_position + Vector2(SPAWN_DISTANCE, 0).rotated(angle)


func get_random_colour() -> Color:
    return PIG_COLOURS[randi() % PIG_COLOURS.size()]
