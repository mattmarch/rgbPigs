extends KinematicBody2D
class_name Player

const COLOURS := [Color(1.3, 0, 0), Color(0, 1, 0), Color(0, 0, 1.6)]

var shell_resource := preload("res://Shell.tscn")

var current_colour := 0

onready var lights := $Lights

func _physics_process(_delta: float):
    var velocity = Globals.PLAYER_SPEED * Vector2(
        Input.get_action_strength("right") - Input.get_action_strength("left"),
        Input.get_action_strength("down") - Input.get_action_strength("up")
       )
    if Input.is_action_pressed("ui_cancel"):
        get_tree().quit()
    move_and_slide(velocity)
    rotation = get_direction_to_mouse()
    if Input.is_action_just_pressed("leftclick"):
        shoot()
    if Input.is_action_just_pressed("rightclick"):
        current_colour = (current_colour + 1) % 3
        set_lights(COLOURS[current_colour])


func get_direction_to_mouse() -> float:
    var vector_to_mouse = 2 * get_global_mouse_position() - get_viewport_rect().size
    return vector_to_mouse.angle()


func set_lights(colour: Color):
    for light in lights.get_children():
        light.color = colour


func shoot():
    var shell = shell_resource.instance()
    shell.global_position = $ShellSpawn.global_position
    shell.rotation = rotation
    get_parent().add_child(shell)
