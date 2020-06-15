extends KinematicBody2D

export (Color) var colour

func _ready():
    $Sprite.modulate = colour
