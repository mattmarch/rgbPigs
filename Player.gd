extends KinematicBody2D

const SPEED := 200

const COLOURS = [Color(1.3, 0, 0), Color(0, 1, 0), Color(0, 0, 1.6)]

var current_colour = 0

onready var lights := $Lights

func _physics_process(_delta: float):
    var velocity = SPEED * Vector2(
        Input.get_action_strength("right") - Input.get_action_strength("left"),
        Input.get_action_strength("down") - Input.get_action_strength("up")
       )
    if Input.is_action_pressed("ui_cancel"):
        get_tree().quit()
    move_and_slide(velocity)
    rotation = get_direction_to_mouse()
    if Input.is_action_just_pressed("leftclick"):
        current_colour = (current_colour + 1) % 3
        set_lights(COLOURS[current_colour])
    if Input.is_action_just_pressed("rightclick"):
        current_colour = (current_colour - 1) % 3
        set_lights(COLOURS[current_colour])


func get_direction_to_mouse() -> float:
    var vector_to_mouse = get_global_mouse_position() - global_position
    return vector_to_mouse.angle()


func set_lights(colour: Color):
    for light in lights.get_children():
        light.color = colour
