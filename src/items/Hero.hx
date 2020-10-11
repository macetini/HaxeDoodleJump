package items;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

/**
 * ...
 * @author J.C. Denton
 */
class Hero extends GameItem
{
	public static inline var RADIUS:Int = 30;
	public static inline var COLOR:UInt = 0x00FF00;
	
	public static inline var JUMP_BORDER:UInt = 150;
	
	public static inline var POWER_JUMP_MULTIPLYER:UInt = 3;

	private var _keys:Array<Bool>;

	private var _horizontalVelocity:Float = 6;

	private var _verticalPull:Float = 1;
	private var _initalJumpPower:Float = 65;
	private var _currentJumpPower:Float = 0;

	private var _isJumping:Bool = false;
	private var _floor:Int;
	
	private var _currentDeltaTime:Float;
	
	private var _isSuperJumpPending:Bool = false;
	
	public var realY(default,null):Float;
	
	public function new()
	{
		super();

		this.graphics.beginFill(COLOR);
		this.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
		this.graphics.endFill();

		_keys = [];		
	}

	public override function addedToStage(event:Event)
	{
		super.addedToStage(event);
		
		_floor = stage.stageHeight;
		realY = this.y;

		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);		
	}

	private function onKeyDown(evt:KeyboardEvent):Void
	{
		_keys[evt.keyCode] = true;
	}

	private function onKeyUp(evt:KeyboardEvent):Void
	{
		_keys[evt.keyCode] = false;
	}

	//TODO - refactor this
	public override function update(deltaTime:Float):Void
	{
		_currentDeltaTime = deltaTime;
		
		if (_isJumping)
		{
			checkJump();
		}
		else if (_keys[Keyboard.SPACE])
		{
			startJump();
		}
		
		checkForThePositionChange();
		
		if (_keys[Keyboard.LEFT])
		{
			moveLeft();
		}

		if (_keys[Keyboard.RIGHT])
		{
			moveRight();
		}
	}

	private function checkJump():Void
	{
		if (realY + this.height >= _floor)
		{
			stopJump();
		}
		else
		{
			doJump();
		}
	}

	public function startJump():Void
	{
		if (_isSuperJumpPending)
		{
			_currentJumpPower = _initalJumpPower * POWER_JUMP_MULTIPLYER;
		}
		else
		{
			_currentJumpPower = _initalJumpPower;
		}
		
		_isSuperJumpPending = false;
		
		realY = this.y;
		_isJumping = true;

		doJump();
	}

	private function doJump():Void
	{
		var jumpMovement:Float = _currentJumpPower * _currentDeltaTime;
		
		if (_currentJumpPower <= 0 || this.y > JUMP_BORDER)
		{
			this.y -= jumpMovement;
		}

		realY -= jumpMovement;

		_currentJumpPower -= _verticalPull;		
	}

	private function stopJump():Void
	{
		_isJumping = false;
		realY = this.y = _floor - this.height;
	}
	
	public function activateSuperJump():Void
	{
		_isSuperJumpPending = true;
		startJump();
	}
	
	public function die():Void
	{
		stopJump();
		this.x = stage.stageWidth / 2 - this.width / 2;
	}
	
	private function checkForThePositionChange():Void
	{
		if (this.x <= -1 * (this.width) )
		{
			this.x = stage.stageWidth;
		}
		else if (this.x >= stage.stageWidth)
		{
			this.x = -1 * (this.width);
		}

	}
	
	private function moveLeft():Void
	{
		this.x -= _horizontalVelocity;
	}

	private function moveRight():Void
	{
		this.x += _horizontalVelocity;
	}
}