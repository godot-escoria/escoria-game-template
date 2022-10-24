# `stop_snd [audio_bus]`
#
# Stops the given audio bus's stream.
#
# By default there are 3 audio buses set up by Escoria : `_sound`, which is
# used to play non-looping sound effects; `_music`, which plays looping music; 
# and `_speech`, which plays non-looping voice files (default: `_music`).
#
# Each simultaneous sound (e.g. multiple game sound effects) will require its 
# own bus. To create additional buses, see the Godot sound documentation :
# [Audio buses](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html#doc-audio-buses)
# 
# **Parameters**
#
# - *audio_bus*: Bus to stop ("_sound", "_music", "_speech", or a custom
#   audio bus you have created.) 
#
# @ESC
extends ESCBaseCommand
class_name StopSndCommand


# The specified sound player
var _snd_player: String

# The previous sound state, saved for interrupting
var previous_snd_state: String


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		0,
		[TYPE_STRING],
		["_music"]
	)


# Validate whether the given arguments match the command descriptor
func validate(arguments: Array):
	if not .validate(arguments):
		return false

	if not escoria.object_manager.has(arguments[0]):
		escoria.logger.error(
			self,
			"[%s]: invalid sound player. Sound player %s not registered."
					% [get_command_name(), arguments[0]]
		)
		return false
	_snd_player = arguments[0]
	return true


# Run the command
func run(command_params: Array) -> int:
	previous_snd_state = escoria.object_manager.get_object(command_params[0]).node.state
	escoria.object_manager.get_object(command_params[0]).node.set_state(
		"off"
	)
	return ESCExecution.RC_OK


# Function called when the command is interrupted.
func interrupt():
	escoria.object_manager.get_object(_snd_player).node.set_state(
		previous_snd_state
	)
