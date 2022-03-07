# `camera_push target [time] [type]`
#
# Pushes the camera to point at a specific `target`.
#
# **Parameters**
#
# - *target*: Global ID of the `ESCItem` to push the camera to. If the target
#   has a child node called `camera_node`, its location will be used. If not,
#   the location of the target will be used
# - *time*: Number of seconds the transition should take (default: `1`)
# - *type*: Transition type to use (default: `QUAD`)
#
# Supported transitions include the names of the values used
# in the "TransitionType" enum of the "Tween" type (without the "TRANS_" prefix):
#
# https://docs.godotengine.org/en/stable/classes/class_tween.html?highlight=tween#enumerations
#
# For more details see: https://docs.escoria-framework.org/camera
#
# @ESC
extends ESCBaseCommand
class_name CameraPushCommand

# The list of supported transitions as per the link mentioned above
const SUPPORTED_TRANSITIONS = ["LINEAR","SINE","QUINT","QUART","QUAD" ,"EXPO","ELASTIC","CUBIC",
	"CIRC","BOUNCE","BACK"]


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		1,
		[TYPE_STRING, [TYPE_REAL, TYPE_INT], TYPE_STRING],
		[null, 1, "QUAD"]
	)


# Validate wether the given arguments match the command descriptor
func validate(arguments: Array):
	if not escoria.object_manager.objects.has(arguments[0]):
		escoria.logger.report_errors(
			"camera_push: invalid object",
			[
				"Object global id %s not found" % arguments[0]
			]
		)
		return false
	if not arguments[3] in SUPPORTED_TRANSITIONS:
		escoria.logger.report_errors(
			"camera_shift: invalid transition type",
			[
				"Transition type {t_type} is not one of the accepted types : {allowed_types}".format(
					{"t_type":arguments[3],"allowed_types":SUPPORTED_TRANSITIONS})
			]
		)
		return false

	return .validate(arguments)


# Run the command
func run(command_params: Array) -> int:
	(escoria.object_manager.get_object(escoria.object_manager.CAMERA).node as ESCCamera)\
		.push(
			escoria.object_manager.get_object(command_params[0]).node,
			command_params[1],
			Tween.new().get("TRANS_%s" % command_params[2])
		)
	return ESCExecution.RC_OK
