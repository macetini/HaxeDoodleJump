package managers.meta;

import openfl.events.Event;

/**
	Enumeration for different types of input events.
**/
enum InputEventType {
	DIR_CHANGE;
	KEY_PRESS;
}

/**
	Event for handling user input in the game.
	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class InputEvent extends Event {
	/**
		Name of the input event.
	**/
	public static inline final NAME:String = "inputEvent";

	final xAxis:Float;
	final inputType:InputEventType;

	public function new(direction:Float, inputType:InputEventType, bubbles:Bool = true, cancelable:Bool = false) {
		super(NAME, bubbles, cancelable);

		this.xAxis = direction;
		this.inputType = inputType;
	}

	/**
		Returns the direction of the input event.
		@return Float The direction of the input event.
	**/
	public function get_xAxis():Float {
		return xAxis;
	}

	/**
		Returns the type of the input event.
		@return InputEventType The type of the input event.
	**/
	public function get_inputType():InputEventType {
		return inputType;
	}

	override public function clone():Event {
		return new InputEvent(xAxis, inputType, bubbles, cancelable);
	}
}