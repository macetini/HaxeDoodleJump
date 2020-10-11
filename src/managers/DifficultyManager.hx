package managers;
import items.Platform;
import spawn.Boost;
import spawn.Fly;

/**
 * ...
 * @author J.C. Denton
 */
class DifficultyManager
{
	public static inline var HEIGHT_DIVIDER:Float = 10;
	
	public static inline var DIFFICULITY_MULTIPLYER:Float = 10;
	
	public var _difficultyThreashold:Float = 100;
	
	private var _height:Float = 0.0;
	
	public function new()
	{
	}
	
	public function increaseHeight(horizontalChange:Float):Float
	{
		_height += horizontalChange / HEIGHT_DIVIDER;
		
		if (_height > _difficultyThreashold)
		{
			increaseDifficulity();
		}
		
		return _height;
	}
	
	private function increaseDifficulity():Void
	{
		_difficultyThreashold *= DIFFICULITY_MULTIPLYER;
		
		Platform.MovableWeight++;
		Platform.BreakableWeight++;
		
		Fly.Weight++;
		Boost.Weight++;
	}
}