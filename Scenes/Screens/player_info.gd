extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_node("ninjaFrog"):
		$healt_ProgressBar.value = get_parent().get_node("ninjaFrog").health
		$FruitPointsLabel.text = "FruitPoints: " + str(get_parent().get_node("ninjaFrog").fruit_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$healt_ProgressBar.value = get_parent().get_node("ninjaFrog").health
	$FruitPointsLabel.text = "FruitPoints: " + str(get_parent().get_node("ninjaFrog").fruit_count)
