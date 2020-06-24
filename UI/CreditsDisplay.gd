extends Control


func _ready():
    $BackButton.connect("pressed", self, "_on_back_pressed")
    $Godot/GodotLicense.connect("pressed", $LicensePopup, "popup")
    $LicensePopup/BackButton.connect("pressed", $LicensePopup, "hide")

func _on_back_pressed():
    visible = false
