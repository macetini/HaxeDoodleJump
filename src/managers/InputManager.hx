package managers;

import managers.meta.InputEvent;
import openfl.ui.Keyboard;
import openfl.events.AccelerometerEvent;
import openfl.sensors.Accelerometer;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

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
		} else if (event.keyCode == Keyboard.RIGHT) {
			direction = 1;
		} else if (event.keyCode == Keyboard.SPACE) {
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

	// Disabled, as the effect is not desired

	@:deprecated
	function onMouseMove(event:MouseEvent) {
		var mouseX:Float = event.stageX;

		var deltaX:Float = mouseX - prevMouseX;
		direction = js.lib.Math.sign(deltaX);
		prevMouseX = mouseX;
	}

	function onAccelerometerUpdate(event:AccelerometerEvent) {
		// Note: The values are in G-forces (m/s² divided by 9.8)
		accelerationX = event.accelerationY; // Use Y-axis tilt for game X movement
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
			} else if (accelerationX < -ACCEL_THRESHOLD) {
				// Tilted left
				finalDirection = -1;
			}
		}

		stage.dispatchEvent(new InputEvent(finalDirection, InputEventType.DIR_CHANGE));
	}
}
