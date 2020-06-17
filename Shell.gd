extends Node2D

const SPEED := 500.0


func _ready():
    $Timer.connect("timeout", self, "_on_timeout")


func _physics_process(delta):
    position += SPEED * delta * Vector2(1, 0).rotated(rotation)
    for body in $Area2D.get_overlapping_bodies():
        if body.has_method("hit"):
            body.hit()
            queue_free()


func _on_timeout():
    queue_free()
