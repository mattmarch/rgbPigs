extends KinematicBody2D

export (Color) var colour := Color(1.0, 0.0, 0.0)
export (float) var turn_speed := 0.03

const FREE_RANGE := 800

var player: Player

var current_turn_speed := 0.0

func _ready():
    $Sprite.modulate = colour
    $RotationTimer.connect("timeout", self, "_on_timer_timeout")


func _physics_process(_delta):
    rotation += current_turn_speed
    move_and_slide(Vector2(-Globals.PIG_SPEED, 0).rotated(rotation))
    if player.global_position.distance_to(global_position) > FREE_RANGE:
        queue_free()
    
    
func _on_timer_timeout():
    if current_turn_speed == 0.0:
        current_turn_speed = rand_range(-turn_speed, turn_speed)
    else:
        current_turn_speed = 0


func hit():
    queue_free()
