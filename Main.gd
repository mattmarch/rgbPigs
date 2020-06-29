extends Node

const BOUNDS := Rect2(512, 300, 1024, 600)
const SPAWN_DISTANCE := Globals.PIG_SPAWN_DIST

const PIG_COLOURS := [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1)]

const PLAYER_START := Vector2(900, 600)

const SPAWN_RATE_INCREASE := 0.1
const FASTEST_SPAWN_INTERVAL := 0.4

const happy_pig_res := preload("res://HappyPig.tscn")
const angry_pig_res := preload("res://AngryPig.tscn")

onready var player: Player = $Player

var angry_pig_chance: float


func _ready():
    $SpawnTimer.connect("timeout", self, "_on_spawn_timer_timeout")
    $SpawnRateTimer.connect("timeout", self, "_on_spawn_rate_timer_timeout")
    Events.connect("start", self, "_on_start")
    Events.connect("game_over", self, "_on_game_over")
    Events.connect("happy_pig_slain", self, "_on_happy_pig_slain")


func _on_start():
    $SpawnTimer.start()
    player.position = PLAYER_START
    angry_pig_chance = 0.2
    Events.emit_signal("update_insanity", angry_pig_chance)

func _on_game_over():
    for child in get_children():
        if child is AngryPig or child is HappyPig:
            child.queue_free()
    $SpawnTimer.stop()


func _on_spawn_timer_timeout():
    spawn_pig()


func _on_spawn_rate_timer_timeout():
    $SpawnTimer.wait_time = clamp($SpawnTimer.wait_time - SPAWN_RATE_INCREASE, FASTEST_SPAWN_INTERVAL, 1)
    print($SpawnTimer.wait_time)


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


func _on_happy_pig_slain():
    angry_pig_chance += 0.1
    Events.emit_signal("update_insanity", angry_pig_chance)
