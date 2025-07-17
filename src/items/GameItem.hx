package items;

import flash.events.Event;
import openfl.display.Sprite;

/**
	GameItem is the base class for all game items in the Doodle Jump game.
	It provides common functionality such as recycling and event handling.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
abstract class GameItem extends Sprite {
	/**
		Delta time multiplier for frame updates.
		This is used to ensure consistent movement and physics calculations across different frame rates.
	**/
	public static inline final DELTA_TIME_MULTIPLIER:Float = 0.01;

	var lastTime:Float;
	var currentTime:Float;
	var diffTime:Float;

	public function new() {
		super();

		this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	/**
		Flag indicating whether the item is pending for recycling.
		When set to true, the item will not be visible and will be recycled when appropriate
	**/
	public var pendingRecycle(default, null) = false;

	/**
		Recycles the item by setting pendingRecycle to true and making it invisible.
		This method should be called when the item is no longer needed.
	**/
	public function recycle() {
		pendingRecycle = true;
		visible = false;
	}

	/**
		Recycles the item after it has been finished with its current task.
	**/
	public function recycleFinished() {
		pendingRecycle = false;
	}

	function addedToStage(event:Event) {
		visible = true;
		lastTime = flash.Lib.getTimer();

		if (!this.hasEventListener(Event.ENTER_FRAME)) {
			this.addEventListener(Event.ENTER_FRAME, tick);
		}
	}

	function removedFromStage(event:Event) {
		if (this.hasEventListener(Event.ENTER_FRAME)) {
			this.removeEventListener(Event.ENTER_FRAME, tick);
		}
	}

	function tick(event:Event) {
		currentTime = flash.Lib.getTimer();
		diffTime = (currentTime - lastTime) * DELTA_TIME_MULTIPLIER;
		lastTime = currentTime;

		update(diffTime);
	}

	/**
		Updates the item based on the time since the last update.
		This method can be overridden by subclasses to implement specific update logic.

		@param deltaTime The time since the last update, in seconds.
	**/
	public function update(deltaTime:Float) {
		// This method can be overridden by subclasses to implement specific update logic.
		// The deltaTime parameter is the time since the last update, in seconds.
	}
}