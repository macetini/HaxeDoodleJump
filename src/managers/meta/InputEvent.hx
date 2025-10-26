package managers.meta;

import openfl.events.Event;

enum InputEventType {
	DIR_CHANGE;
	KEY_PRESS;
}

class InputEvent extends Event {
	public static inline final NAME:String = "inputEvent";

	final xAxis:Float;
	final inputType:InputEventType;

	public function new(direction:Float, inputType:InputEventType, bubbles:Bool = true, cancelable:Bool = false) {
		super(NAME, bubbles, cancelable);

		this.xAxis = direction;
		this.inputType = inputType;
	}

	public function get_xAxis():Float {
		return xAxis;
	}

	public function get_inputType():InputEventType {
		return inputType;
	}

	override public function clone():Event {
		return new InputEvent(xAxis, inputType, bubbles, cancelable);
	}
}
