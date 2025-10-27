package managers;

import openfl.text.TextField;
import managers.meta.InputEvent;
import openfl.ui.Keyboard;
import openfl.events.AccelerometerEvent;
import openfl.sensors.Accelerometer;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

/**
	InputManager is responsible for handling user input in the game.
	It handles keyboard and mouse input, as well as accelerometer input if available.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class InputManager {
	// --- Stage Reference (dispatches events) ---
	var stage:Stage;

	// Direction is set by keyboard handlers, but will be calculated in update()
	var direction:Float;
	var prevMouseX:Float;

	// A threshold to filter out tiny movements from the accelerometer (e.g., 0.2 G's)
	static inline final ACCEL_THRESHOLD:Float = 0.2;
	// --- Accelerometer Update Interval in Milliseconds ---
	static inline final ACCEL_UPDATE_INTERVAL:UInt = 200;
	static inline final ACCEL_TITLE_THRESHOLD:Float = 0.2;

	// --- Sensor Data Tracking ---
	var accelerometer:Accelerometer;
	var accTextField:TextField;

	public function new(stage:Stage) {
		this.stage = stage;

		direction = 0;
		prevMouseX = 0;

		setupKeyboardEvents();
		setupMouseEvents();
		setupAccelerometer();
	}

	// --- Keyboard Event Handlers ---
	function setupKeyboardEvents() {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.LEFT) {
			direction = -1;
		}
		else if (event.keyCode == Keyboard.RIGHT) {
			direction = 1;
		}
		else if (event.keyCode == Keyboard.SPACE) {
			stage.dispatchEvent(new InputEvent(0, InputEventType.KEY_PRESS));
		}
	}

	function onKeyUp(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT) {
			direction = 0;
		}
	}

	// --- Mouse Event Handlers ---
	function setupMouseEvents() {
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		// stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove); // Disabled, as the movement is not easy to control
	}

	function onMouseDown(event:MouseEvent) {
		stage.dispatchEvent(new InputEvent(0, InputEventType.KEY_PRESS));
	}

	// Disabled, mouse movement is difficult to control
	@:deprecated
	function onMouseMove(event:MouseEvent) {
		var mouseX:Float = event.stageX;

		var deltaX:Float = mouseX - prevMouseX;
		direction = deltaX / Math.abs(deltaX);
		prevMouseX = mouseX;
	}

	function setupAccelerometer() {
		accTextField = new TextField();
		accTextField.autoSize = LEFT;
		accTextField.text = "";
		stage.addChild(accTextField);

		// Initialize accelerometer object
		if (Accelerometer.isSupported) {
			accelerometer = new Accelerometer();
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			// update interval (in milliseconds)
			accelerometer.setRequestedUpdateInterval(ACCEL_UPDATE_INTERVAL);
		}
		else {
			accTextField.text = "Accelerometer not supported!";
		}
	}

	function onAccelerometerUpdate(event:AccelerometerEvent) {
		var normalizedTiltX:Float = 0.0;
		var normalizedTiltY:Float = 0.0;

		var rawX:Float = event.accelerationX;
		var rawY:Float = event.accelerationY;
		var magnitude:Float = Math.sqrt(rawX * rawX + rawY * rawY);

		if (magnitude > 0) {
			normalizedTiltX = rawX / magnitude;
			normalizedTiltY = rawY / magnitude;
		}

		// Cheap hack for portrait mode, not perfect but good enough
		var finalDirection:Float = Math.abs(normalizedTiltX) < 0.8 ? normalizedTiltX : normalizedTiltY;

		if (Math.abs(finalDirection) > ACCEL_TITLE_THRESHOLD) {
			direction = -finalDirection;
		}
	}

	/**
		Called every frame to calculate and dispatch the current movement direction.
		Combines keyboard/mouse state (this.direction) with accelerometer data.
	**/
	public function update() {
		stage.dispatchEvent(new InputEvent(direction, InputEventType.DIR_CHANGE));
	}
}