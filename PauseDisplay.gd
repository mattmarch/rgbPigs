extends Control


func _process(_delta):
    if Input.is_action_just_pressed("ui_cancel"):
        var is_paused = get_tree().paused
        visible = !is_paused
        get_tree().paused = !is_paused
