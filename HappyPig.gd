extends KinematicBody2D
class_name HappyPig

export (Color) var colour := Color(1.0, 0.0, 0.0)
export (float) var turn_speed := 0.03

const FREE_RANGE := 800

var player: Player

var current_turn_speed := 0.0
var stopped := false


func _ready():
    $Sprite.modulate = colour
    $RotationTimer.connect("timeout", self, "_on_timer_timeout")
    $DeathTimer.connect("timeout", self, "_on_death_timer_timeout")

func _physics_process(_delta):
    if stopped:
        return
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
    Events.emit_signal("happy_pig_slain")
    $HitParticles.emitting = true
    stopped = true
    $DeathTimer.start()
    $CollisionShape2D.disabled = true


func _on_death_timer_timeout():
    queue_free()
