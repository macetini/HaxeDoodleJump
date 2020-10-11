package spawn;
import flash.events.Event;

/**
 * ...
 * @author J.C. Denton
 */
class Fly extends SpawnItem
{
	public static inline var HEIGHT:Int = 50;
	public static inline var WIDTH:Int = 25;
	public static inline var ELIPSE_RADIUS:Int = 5;
	
	public static inline var WAVE_HEIGHT:Int = 5;
	public static inline var WAVE_LENGTH:Int = 10;
	
	public static inline var INIT_POSITION_STAGE_HIGHT_DIVIDER:Int = 2;
	
	public static inline var COLOR:UInt = 0xFF3800;

	
	//public static inline 
	
	/**
	 * Time necessary to pass for respawn
	 */
	public static var TimeOut:Float = 50;

	/**
	 * Respawn time counter
	 */
	public static var TimeOutCounter:Float = TimeOut;

	/**
	 * Entity weight
	 */
	public static var Weight:Float = 0;
	
	private var _direction:Int;
	
	public function new()
	{
		super();
		
		this.graphics.beginFill(COLOR);
		this.graphics.drawRoundRect(0, 0, HEIGHT, WIDTH, ELIPSE_RADIUS, ELIPSE_RADIUS);
		this.graphics.endFill();
	}
	
	override public function addedToStage(event:Event):Void
	{
		super.addedToStage(event);
		
		_direction = Math.random() > 0.5 ? -1 : 1;
		
		if (_direction < 0)
		{
			this.x = stage.stageWidth;
		}
		else
		{
			this.x = 0;
		}
		
		this.y = Math.random() * (stage.stageHeight >> INIT_POSITION_STAGE_HIGHT_DIVIDER);
	}
	
	override public function update(deltaTime:Float):Void
	{
		super.update(deltaTime);
		
		sineWave(_direction, WAVE_HEIGHT, WAVE_LENGTH, this.y);
	}
	
	/**
	* Moves entity in sine wave ( y = A * sin(B/x) + yInit ).
	*
	* @param speed Speed of the entity movement.
	* @param waveHeight Amplitude or Wave height.
	* @param waveLength Period or Wave length.
	* @param waveLength Y coordinate starting position
	*
	*/
	public function sineWave(speed:Int, waveHeight:Int, waveLength:Int, yStartPosition:Float):Void
	{
		this.x += speed;
		this.y = (waveHeight * Math.sin(this.x / waveLength)) + yStartPosition;
	}
}