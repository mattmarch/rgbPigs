extends KinematicBody2D

export (Color) var colour := Color(1.0, 0.0, 0.0)
export (float) var turn_speed := 0.03

const TRIGGER_RANGE := Globals.ANGRY_PIG_TRIGGER_RANGE
const FREE_RANGE := Globals.ANGRY_PIG_DESPAWN_DIST

var current_turn_speed := 0.0

var player: Player

enum Directions {LEFT = 1, RIGHT = -1}

func _ready():
    $Sprite.modulate = colour
    $RotationTimer.connect("timeout", self, "_on_timer_timeout")


func _physics_process(_delta):
    if !is_player_nearby():
        rotation += current_turn_speed 
    else:
        rotation += -direction_to_turn(player.position) * turn_speed
    move_and_slide(Vector2(-Globals.PIG_SPEED, 0).rotated(rotation))
    if player.global_position.distance_to(global_position) > FREE_RANGE:
        queue_free()
    
    
func _on_timer_timeout():
    if current_turn_speed == 0.0:
        current_turn_speed = rand_range(-turn_speed, turn_speed)
    else:
        current_turn_speed = 0


func is_player_nearby() -> bool:
    return player.global_position.distance_to(global_position) < TRIGGER_RANGE
 

func direction_to_turn(target: Vector2) -> int:
    var angle_to = get_angle_to(target)
    return Directions.LEFT if angle_to > 0 else Directions.RIGHT 


func hit():
    queue_free()
