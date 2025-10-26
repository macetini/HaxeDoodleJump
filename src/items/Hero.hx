package items;

import flash.events.Event;
import flash.ui.Keyboard;

/**
	Hero class represents the player character in the Doodle Jump game.
	It handles player input, movement, and jumping mechanics.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class Hero extends GameItem {
	/**
		The radius of the hero character.
		This is used for collision detection and rendering.
	**/
	public static inline final RADIUS:Int = 30;

	static inline final COLOR:UInt = 0x00FF00;
	static inline final JUMP_BORDER:UInt = 150;
	static inline final POWER_JUMP_MULTIPLAYER:UInt = 3;

	var keys:Array<Bool>;

	var horizontalVelocity:Float;
	var verticalPull:Float;
	var initialJumpPower:Float;
	var currentJumpPower:Float;
	var isJumping:Bool;
	var floor:Int;

	var currentDeltaTime:Float;
	var isSuperJumpPending:Bool;

	/**
		The real Y position of the hero, used for calculations.
		This is different from the display Y position due to the jumping mechanics.
	**/
	public var realY(default, null):Float;

	public function new() {
		super();

		keys = [];

		horizontalVelocity = 6;
		verticalPull = 1;
		initialJumpPower = 65;
		currentJumpPower = 0;
		isJumping = false;
		isSuperJumpPending = false;

		this.graphics.beginFill(COLOR);
		this.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
		this.graphics.endFill();
	}

	override public function addedToStage(event:Event) {
		super.addedToStage(event);

		floor = stage.stageHeight;
		realY = this.y;
	}

	/**
		Handles Key Down events to update the hero's movement state.
		@param keyCode Key code of the released key.
	**/
	public function onKeyDown(keyCode:Int) {
		keys[keyCode] = true;
	}

	/**
		Handles Key Up events to update the hero's movement state.
		@param keyCode Key code of the released key.
	**/
	public function onKeyUp(keyCode:Int) {
		keys[keyCode] = false;
	}

	override public function update(deltaTime:Float) {
		currentDeltaTime = deltaTime;

		if (isJumping) {
			checkJump();
		}
		else if (keys[Keyboard.SPACE]) {
			startJump();
		}

		checkForThePositionChange();

		if (keys[Keyboard.LEFT]) {
			moveLeft();
		} else if (keys[Keyboard.RIGHT]) {
			moveRight();
		}
	}

	function checkJump() {
		if (realY + this.height >= floor) {
			stopJump();
		} else {
			doJump();
		}
	}

	/**
		Starts the jump process. If a super jump is pending, it uses a higher jump power.
		Otherwise, it uses the initial jump power.	
	**/
	public function startJump() {
		if (isSuperJumpPending) {
			currentJumpPower = initialJumpPower * POWER_JUMP_MULTIPLAYER;
		} else {
			currentJumpPower = initialJumpPower;
		}
		isSuperJumpPending = false;
		realY = this.y;
		isJumping = true;
		doJump();
	}

	function doJump() {
		var jumpMovement:Float = currentJumpPower * currentDeltaTime;

		if (currentJumpPower <= 0 || this.y > JUMP_BORDER) {
			this.y -= jumpMovement;
		}
		realY -= jumpMovement;
		currentJumpPower -= verticalPull;
	}

	function stopJump() {
		isJumping = false;
		realY = this.y = floor - this.height;
	}

	/**
		Activates a super jump, which allows the hero to jump higher than normal.
	**/
	public function activateSuperJump() {
		isSuperJumpPending = true;
		startJump();
	}

	/**
		Resets the hero's position to the center of the stage and stops any jumping.
	**/
	public function die() {
		stopJump();
		this.x = stage.stageWidth / 2 - this.width / 2;
	}

	function checkForThePositionChange() {
		if (this.x <= -1 * (this.width)) {
			this.x = stage.stageWidth;
		} else if (this.x >= stage.stageWidth) {
			this.x = -1 * (this.width);
		}
	}

	function moveLeft() {
		this.x -= horizontalVelocity;
	}

	function moveRight() {
		this.x += horizontalVelocity;
	}
}
