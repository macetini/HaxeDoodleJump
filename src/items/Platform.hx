package items;

import flash.events.Event;
import items.GameItem;

/**
 * ...
 * @author J.C. Denton
 */
class Platform extends GameItem
{
	public static inline var HEIGHT:Int = 20;
	public static inline var WIDTH:Int = 100;
	
	public static inline var NORMAL_COLOR:UInt = 0x00FFFF;
	public static inline var BREAKABLE_COLOR:UInt = 0x302013;
	public static inline var MOVABLE_COLOR:UInt = 0xFF00FF;
	
	public static var NormalWeight:Int = 10;
	public static var BreakableWeight:Int = 0;
	public static var MovableWeight:Int = 0;
	
	private var _direction:Int;
	
	private var _movable:Bool = false;
	
	public var normal(default, null):Bool = false;
	public var breakable(default, null):Bool = false;
	
	public var hasBoost(default, default):Bool;	
	
	public function new() 
	{
		super();
	}
	
	override public function removedFromStage(event:Event):Void
	{
		super.removedFromStage(event);
		
		resetPlatform();
	}
	
	public function resetPlatform():Void
	{
		hasBoost = normal = breakable = _movable = false;
		
		this.graphics.clear();
	}
	
	override public function addedToStage(event:Event):Void
	{
		super.addedToStage(event);
		
		initPlatform();
	}
	
	//TODO - REFACTOR - Factory pattern maybe.
	private function initPlatform():Void
	{
		_direction = Math.random() > 0.5 ? -1 : 1;
		
		var total:UInt = NormalWeight + BreakableWeight + MovableWeight;
		
		var chance:Float = total * Math.random();
		
		chance -= NormalWeight;
		
		if (chance <= 0)
		{
			normal = true;
			drawColor(NORMAL_COLOR);

			return;
		}
		
		chance -= BreakableWeight;
		
		if (chance <= 0)
		{
			breakable = true;
			drawColor(BREAKABLE_COLOR);
			
			return;
		}
		
		chance -= MovableWeight;
		
		if (chance <= 0)
		{
			_movable = true;
			drawColor(MOVABLE_COLOR);
		}
	}
	
	private function drawColor(color:UInt):Void
	{
		this.graphics.beginFill(color);
		this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		this.graphics.endFill();
	}
	
	override public function update(deltaTime:Float):Void
	{
		if (_movable)
		{
			movePlatform(deltaTime);
		}
	}
	
	private function movePlatform(deltaTime:Float):Void
	{
		if (this.x + this.width >= stage.stageWidth || this.x <= 0)
		{
			_direction *= -1;
		}
		
		this.x += _direction;
	}
}