package items;

import flash.events.Event;
import openfl.display.Sprite;

/**
 * ...
 * @author J.C. Denton
 */
class GameItem extends Sprite
{
	public static  inline var DELTA_TIME_MULTIPLIER:Float = 0.01;
	
	private var _lastTime:Float;
	private var _currentTime:Float;
	private var _diffTime:Float;
	
	public var pendingRecycle(default, null) = false;
	
	public function recycle():Void
	{
		pendingRecycle = true;
		visible = false;
	}
	
	public function recycleFinished():Void
	{	
		pendingRecycle = false;
		visible = true;		
	}

	public function new()
	{
		super();

		this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);		
		this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	public function addedToStage(event:Event):Void
	{
		_lastTime = flash.Lib.getTimer();

		if (!this.hasEventListener(Event.ENTER_FRAME))
		{
			this.addEventListener(Event.ENTER_FRAME, tick);
		}
	}
	
	public function removedFromStage(event:Event):Void
	{
		if (this.hasEventListener(Event.ENTER_FRAME))
		{
			this.removeEventListener(Event.ENTER_FRAME, tick);
		}
	}

	private function tick(event:Event):Void
	{
		_currentTime = flash.Lib.getTimer();
		
		_diffTime = (_currentTime - _lastTime) * DELTA_TIME_MULTIPLIER;

		_lastTime = _currentTime;

		update(_diffTime);
	}

	public function update(deltaTime:Float):Void
	{
		//trace(elapsedTime);
	}

}