extends Control

var is_game_started := false


func _ready():
    Events.connect("game_over", self, "_on_game_over")
    Events.connect("start", self, "_on_start")
    $ResumeButton.connect("pressed", self, "_on_resume_pressed")
    $SettingsButton.connect("pressed", self, "_on_settings_pressed")
    $MainMenuButton.connect("pressed", self, "_on_main_menu_pressed")


func _process(_delta):
    if Input.is_action_just_pressed("ui_cancel") and is_game_started:
        var is_paused = get_tree().paused
        visible = !is_paused
        get_tree().paused = !is_paused


func _on_game_over():
    is_game_started = false
    

func _on_start():
    is_game_started = true


func _on_resume_pressed():
    get_tree().paused = false
    visible = false


func _on_settings_pressed():
    $SettingsDisplay.visible = true


func _on_main_menu_pressed():
    get_tree().paused = false
    visible = false
    Events.emit_signal("game_exited")
