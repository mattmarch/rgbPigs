extends KinematicBody2D

export (Color) var colour := Color(1.0, 0.0, 0.0)
export (float) var speed := 50
export (float) var turn_speed := 0.03

var current_turn_speed := 0.0

enum Directions {LEFT = 1, RIGHT = -1}

func _ready():
    $Sprite.modulate = colour
    $RotationTimer.connect("timeout", self, "_on_timer_timeout")


func _physics_process(_delta):
    var player := get_nearby_player()
    if player == null:
        rotation += current_turn_speed 
    else:
        rotation += -direction_to_turn(player.position) * turn_speed
    move_and_slide(Vector2(-speed, 0).rotated(rotation))
    
    
func _on_timer_timeout():
    if current_turn_speed == 0.0:
        current_turn_speed = rand_range(-turn_speed, turn_speed)
    else:
        current_turn_speed = 0


func get_nearby_player() -> Player:
    for body in $DetectionArea.get_overlapping_bodies():
        if body is Player:
            return body
    return null
 

func direction_to_turn(target: Vector2) -> int:
    var angle_to = get_angle_to(target)
    return Directions.LEFT if angle_to > 0 else Directions.RIGHT 
