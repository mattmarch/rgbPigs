extends KinematicBody2D
class_name Player

const COLOURS := [Color(1.3, 0, 0), Color(0, 1, 0), Color(0, 0, 2.0)]

var shell_resource := preload("res://Shell.tscn")

var shells := 2
var current_colour := 0
var started := false

onready var lights := $Lights


func _ready():
    $ReloadTimer.connect("timeout", self, "_on_reload_timer_timeout")
    Events.connect("game_over", self, "_on_game_over")
    Events.connect("game_exited", self, "_on_game_exited")
    Events.connect("start", self, "_on_start")
    Events.connect("player_hit", self, "_on_player_hit")


func _physics_process(_delta: float):
    if !started:
        return
    var velocity = Globals.PLAYER_SPEED * Vector2(
        Input.get_action_strength("right") - Input.get_action_strength("left"),
        Input.get_action_strength("down") - Input.get_action_strength("up")
       )
    move_and_slide(velocity)
    rotation = get_direction_to_mouse()
    if Input.is_action_just_pressed("leftclick"):
        shoot()
    if Input.is_action_just_pressed("rightclick"):
        current_colour = (current_colour + 1) % 3
        set_lights(COLOURS[current_colour])
    # For debugging only, remove later!
    if Input.is_action_just_pressed("debug_hit"):
        Events.emit_signal("player_hit")


func get_direction_to_mouse() -> float:
    var vector_to_mouse = 2 * get_global_mouse_position() - get_viewport_rect().size
    return vector_to_mouse.angle()


func set_lights(colour: Color):
    for light in lights.get_children():
        light.color = colour


func shoot():
    if shells > 0:
        var shell = shell_resource.instance()
        shell.global_position = $ShellSpawn.global_position
        shell.rotation = rotation
        get_parent().add_child(shell)
        shells -= 1
        Events.emit_signal("update_shells", shells)
        if shells == 0:
            $ReloadTimer.start()
            SoundEffects.shoot_and_reload()
        else:
            SoundEffects.shoot()
            
                

func _on_reload_timer_timeout():
    shells = 2
    Events.emit_signal("update_shells", shells)


func _on_game_over():
    started = false
    
func _on_game_exited():
    started = false
    

func _on_start():
    started = true
    shells = 2
    Events.emit_signal("update_shells", shells)
    

func _on_player_hit():
    if $HitParticles.emitting:
        $HitParticles.restart()
    else:
        $HitParticles.emitting = true
