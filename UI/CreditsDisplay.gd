extends Control


func _ready():
    $BackButton.connect("pressed", self, "_on_back_pressed")


func _on_back_pressed():
    visible = false
