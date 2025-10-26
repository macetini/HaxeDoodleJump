package managers;

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
	// --- Accelerometer Update Interval in Milliseconds (~30 FPS) ---
	static inline final UPDATE_INTERVAL:UInt = 33;

	// --- Sensor Data Tracking ---
	var accelerometer:Accelerometer;
	var accelerationX:Float;

	public function new(stage:Stage) {
		this.stage = stage;

		direction = 0;
		prevMouseX = 0;

		setupKeyboardEvents();
		setupMouseEvents();

		// Initialize accelerometer object
		if (Accelerometer.isSupported) {
			accelerometer = new Accelerometer();
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
			// update interval (in milliseconds)
			accelerometer.setRequestedUpdateInterval(UPDATE_INTERVAL); // ~30 FPS
		}
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
		// stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove); // Disabled, as the effect is not desired
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

	function onAccelerometerUpdate(event:AccelerometerEvent) {
		// Get the absolute (magnitude) of the X and Y sensor readings
		var absX:Float = Math.abs(event.accelerationX);
		var absY:Float = Math.abs(event.accelerationY);

		// Determine which axis (X or Y) is currently experiencing the greatest tilt
		if (absX > absY) {
			// The device is mostly in PORTRAIT orientation (or near it).
			// Sensor's X-axis is dominant.

			// FIX: In portrait mode, tilting right gives a NEGATIVE X-acceleration.
			// We must invert the sign to match the expected direction (right = positive).
			accelerationX = -event.accelerationX;
		}
		else {
			// The device is mostly in LANDSCAPE orientation (or near it).
			// Sensor's Y-axis is dominant.

			// This was already correct: tilting the device right (usually positive Y-acceleration) 
			// needs to be inverted to align with the game's X-direction.
			accelerationX = event.accelerationY;
		}
	}

	/**
		Called every frame to calculate and dispatch the current movement direction.
		Combines keyboard/mouse state (this.direction) with accelerometer data.
	**/
	public function update() {
		var finalDirection:Float = direction; // Start with current keyboard/mouse state

		// If accelerometer is supported and keyboard/mouse isn't providing input (direction == 0)
		if (accelerometer != null && direction == 0) {
			if (accelerationX > ACCEL_THRESHOLD) {
				// Tilted right
				finalDirection = 1;
			}
			else if (accelerationX < -ACCEL_THRESHOLD) {
				// Tilted left
				finalDirection = -1;
			}
		}

		stage.dispatchEvent(new InputEvent(finalDirection, InputEventType.DIR_CHANGE));
	}
}