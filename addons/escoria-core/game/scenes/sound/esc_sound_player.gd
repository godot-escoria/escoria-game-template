# Background sound player
extends Control
class_name ESCSoundPlayer


# Global id of the background sound player
@export var global_id: String = "_sound"


# The state of the sound player. "default" or "off" disable sound
# Any other state refers to a sound stream that should be played
var state: String = "default"


# Reference to the audio player
@onready var stream: AudioStreamPlayer = $AudioStreamPlayer


# Set the state of this player
#
# #### Parameters
#
# - p_state: New state to use
# - from_seconds: Sets the starting playback position
# - p_force: Override the existing state even if the stream is still playing
func set_state(p_state: String, from_seconds: float = 0.0, p_force: bool = false):
	# If already playing this stream, keep playing, unless p_force
	if p_state == state and not p_force and stream.is_playing():
		return

	state = p_state

	# If state is "off"/"default", turn off music
	if state == "off" or state == "default":
		stream.stream = null
		return

	var resource = load(p_state)

	stream.stream = resource

	if stream.stream:
		if resource is AudioStreamWAV:
			resource.loop_mode = AudioStreamWAV.LOOP_DISABLED
		elif "loop" in resource:
			resource.loop = false
		stream.play(from_seconds)


# Register to the object registry
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	escoria.object_manager.register_object(
		ESCObject.new(global_id, self),
		null,
		true
	)


# Set state to default when finished playing.
func _on_sound_finished():
	state = "default"


# Returns the playback position of the audio stream in seconds
#
# **Returns** playback position
func get_playback_position() -> float:
	return $AudioStreamPlayer.get_playback_position()
