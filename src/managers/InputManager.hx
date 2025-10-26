package managers;

import openfl.events.Event;
import openfl.events.AccelerometerEvent;
import openfl.sensors.Accelerometer;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

enum abstract MouseButton(Int) from Int to Int {
	var LEFT = 0;
	var MIDDLE = 1;
	var RIGHT = 2;
}

enum abstract KeyEventType(Int) from Int to Int {
	var UP = 0;
	var DOWN = 1;
}

class KeyEvent extends Event {
	public static inline var EVENT:String = "keyEvent";

	var keyCode:Int;
	var eventType:KeyEventType;

	public function new(keyCode:Int, eventType:KeyEventType, bubbles:Bool = true, cancelable:Bool = false) {
		super(EVENT, bubbles, cancelable);

		this.keyCode = keyCode;
		this.eventType = eventType;
	}

	public function get_keyCode():Int {
		return keyCode;
	}

	public function get_eventType():KeyEventType {
		return eventType;
	}

	override public function clone():Event {
		return new KeyEvent(keyCode, eventType, bubbles, cancelable);
	}
}

class InputManager {
	// --- Stage Reference (dispatches events) ---
	var stage:Stage;

	// --- Mouse Button State Tracking ---
	var mouseButtonsDown:Map<Int, Bool>;
	var mouseButtonsJustPressed:Map<Int, Bool>;
	var mouseButtonsWasDown:Map<Int, Bool>;

	// --- Sensor Data Tracking ---
	var accelerationX:Float;
	var accelerationY:Float;
	var accelerationZ:Float;

	var accelerometer:Accelerometer;

	var mouseX:Float;
	var mouseY:Float;

	public function new(stage:Stage) {
		this.stage = stage;

		mouseButtonsDown = new Map<Int, Bool>();
		mouseButtonsJustPressed = new Map<Int, Bool>();
		mouseButtonsWasDown = new Map<Int, Bool>();

		setupKeyboardEvents();
        setupMouseEvents();

		// Initialize accelerometer object
		if (Accelerometer.isSupported) {
			accelerometer = new Accelerometer();
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			// update interval (in milliseconds)
			accelerometer.setRequestedUpdateInterval(33); // ~30 FPS
		}
	}

	// --- Event Handlers ---
	function setupKeyboardEvents() {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	function onKeyDown(event:KeyboardEvent) {
		stage.dispatchEvent(new KeyEvent(event.keyCode, KeyEventType.DOWN));
	}

	function onKeyUp(event:KeyboardEvent) {
		stage.dispatchEvent(new KeyEvent(event.keyCode, KeyEventType.UP));
	}

	function setupMouseEvents() {
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	}

	function onMouseDown(event:MouseEvent) {
		// Use event.button for left/middle/right (0, 1, 2 typically)
		/*if (!mouseButtonsDown.get(event.button)) {
				mouseButtonsJustPressed.set(event.button, true);
			}
			mouseButtonsDown.set(event.button, true); */
	}

	function onMouseUp(event:MouseEvent) {
		// mouseButtonsDown.set(event.button, false);
	}

	function onMouseMove(event:MouseEvent) {
		mouseX = event.stageX;
		mouseY = event.stageY;
	}

	function onAccelerometerUpdate(event:AccelerometerEvent) {
		// The Y-axis often corresponds to the device's tilt left/right (used for X movement)
		// The X-axis often corresponds to the device's tilt forward/backward (used for Y movement)
		// The axes are normalized to the display orientation in OpenFL.

		// Note: The values are in G-forces (m/s² divided by 9.8)
		accelerationX = event.accelerationY; // Use Y-axis tilt for game X movement
		accelerationY = event.accelerationX; // Use X-axis tilt for game Y movement
		accelerationZ = event.accelerationZ;
	}
}
