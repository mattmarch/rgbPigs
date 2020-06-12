extends StaticBody2D

export (Color) var color

func _ready():
    $Sprite.modulate = color
