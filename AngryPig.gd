extends KinematicBody2D
class_name AngryPig

export (Color) var colour := Color(1.0, 0.0, 0.0)
export (float) var turn_speed := 0.03

const TRIGGER_RANGE := Globals.ANGRY_PIG_TRIGGER_RANGE
const FREE_RANGE := Globals.ANGRY_PIG_DESPAWN_DIST
const ATTACK_DISTANCE := 35.0

var current_turn_speed := 0.0

var player: Player

var has_just_attacked := false
var stopped := false

enum Directions {LEFT = 1, RIGHT = -1}


func _ready():
    $Sprite.modulate = colour
    $RotationTimer.connect("timeout", self, "_on_rotation_timer_timeout")
    $CooldownTimer.connect("timeout", self, "_on_cooldown_timer_timeout")
    $DeathTimer.connect("timeout", self, "_on_death_timer_timeout")
    $AttackTimer.connect("timeout", self, "_on_attack_timer_timeout")


func _physics_process(_delta):
    if stopped:
        return
    if !is_player_nearby():
        rotation += current_turn_speed 
    else:
        rotation += -direction_to_turn(player.position) * turn_speed
    move_and_slide(get_velocity())
    if !has_just_attacked and $AttackTimer.is_stopped():
        for collision_index in get_slide_count():
            var collision = get_slide_collision(collision_index)
            if collision.collider is Player:
                $AttackTimer.start()
                break
    if player.global_position.distance_to(global_position) > FREE_RANGE:
        queue_free()
    
    
func _on_rotation_timer_timeout():
    if current_turn_speed == 0.0:
        current_turn_speed = rand_range(-turn_speed, turn_speed)
    else:
        current_turn_speed = 0


func _on_cooldown_timer_timeout():
    has_just_attacked = false


func is_player_nearby() -> bool:
    return player.global_position.distance_to(global_position) < TRIGGER_RANGE
 

func direction_to_turn(target: Vector2) -> int:
    var angle_to = get_angle_to(target)
    return Directions.LEFT if angle_to > 0 else Directions.RIGHT 


func get_velocity():
    return Vector2(
        Globals.PIG_SPEED * (1 if has_just_attacked else -1),
        0
       ).rotated(rotation)


func hit():
    Events.emit_signal("demon_pig_slain")
    $HitParticles.emitting = true
    $DeathTimer.start()
    stopped = true
    

func _on_death_timer_timeout():
    queue_free()


func _on_attack_timer_timeout():
    if stopped or player.global_position.distance_to(global_position) > ATTACK_DISTANCE:
        return
    Events.emit_signal("player_hit")
    $CooldownTimer.start()
    has_just_attacked = true
