package spawn;

/**
 * ...
 * @author J.C. Denton
 */
class Boost extends SpawnItem
{
	public static inline var HEIGHT:UInt = 20;
	public static inline var WIDTH:UInt = 25;
	
	public static inline var COLOR:UInt = 0x0000FF;
	
	/**
	 * Time necessary to pass for respawn
	 */
	public static var TimeOut:Float = 20;

	/**
	 * Respawn time counter
	 */
	public static var TimeOutCounter:Float = TimeOut;

	/**
	 * Entity weight
	 */
	public static var Weight:Float = 0;

	public function new()
	{
		super();

		this.graphics.beginFill(COLOR);
		this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		this.graphics.endFill();
	}
}