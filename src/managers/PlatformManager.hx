package managers;
import items.Platform;
import openfl.display.Sprite;

/**
 * ...
 * @author J.C. Denton
 */
class PlatformManager
{
	public static inline var MAX_NUMBER_OF_PLATFORMS:Int = 30;
	public static inline var FLOOR_OFFSET:Int = 165;
	public static inline var SOON_VISIBLE_OFFSET:UInt = 30;

	public static inline var MINI_PLATFORM_VER_DISTANCE:Float = 25;
	public static inline var MAX_PLATFORM_VER_DISTANCE:Float = 100;
	
	private var _stageHeight:Float;
	private var _stageWidth:Float;

	private var _platforms:Array<Platform>;	
	
	private var _layer:Sprite;

	public function new(layer:Sprite)
	{
		_layer = layer;
		
		_stageHeight = layer.stage.stageHeight;
		_stageWidth = layer.stage.stageWidth;
		
		createPlatforms();
	}
	
	private function createPlatforms():Void
	{
		_platforms = new Array<Platform>();

		var newPlatform:Platform;
		
		var _lastPlatformtY:Float = 0.0;

		for (i in 0...MAX_NUMBER_OF_PLATFORMS)
		{
			newPlatform = new Platform();
			newPlatform.y = _lastPlatformtY;

			_lastPlatformtY -= getNewPlatformOffest_Y();

			_platforms.push(newPlatform);
		}		
	}
	
	public function addPlatforms():Void
	{
		var visiblePlaforms:List<Platform> = getVisiblePlaforms();

		for (platform in visiblePlaforms)
		{
			_layer.addChild(platform);
		}

		adjustPlatformsInitPos();
	}

	private function getNewPlatformOffest_Y():Float
	{
		return Platform.HEIGHT + (MAX_PLATFORM_VER_DISTANCE * Math.random()) + MINI_PLATFORM_VER_DISTANCE;
	}

	private function getNewPlatformOffest_X():Float
	{
		return  (_stageWidth - Platform.WIDTH) * Math.random();
	}

	public function adjustPlatformsInitPos():Void
	{
		for (platform in _platforms)
		{
			platform.y += _stageHeight - FLOOR_OFFSET;
			platform.x = getNewPlatformOffest_X();
		}
	}
	
	public function addSoonVisiblePlatforms():Void
	{
		var soonVisiblePlaforms:List<Platform> = getSoonVisiblePlaforms();

		for (platform in soonVisiblePlaforms)
		{
			_layer.addChild(platform);
		}
	}

	public function getVisiblePlaforms():List<Platform>
	{
		var visiblePlaforms:List<Platform> = new List<Platform>();

		var lowBorder:Float;

		for (platform in _platforms)
		{
			lowBorder = platform.y;

			if (platform.y >= 0 && platform.y <= _stageHeight)
			{
				visiblePlaforms.add(platform);
			}
			else
			{
				break;
			}
		}

		return visiblePlaforms;
	}

	public function getSoonVisiblePlaforms():List<Platform>
	{
		var soonVisiblePlaforms:List<Platform> = new List<Platform>();

		for (platform in _platforms)
		{
			if (platform.y + Platform.HEIGHT <= _stageHeight + SOON_VISIBLE_OFFSET)
			{
				soonVisiblePlaforms.add(platform);
			}
			else
			{
				break;
			}
		}

		return soonVisiblePlaforms;
	}
	
	public function returnLastBoostablePlatform():Platform
	{
		var retPlatform:Platform;
		
		var i = _platforms.length;		
		while (--i >= 0) 
		{
			retPlatform = _platforms[i];
			
			if (retPlatform.normal && !retPlatform.hasBoost)
			{
				return retPlatform;
			}
		}
		
		return null;
	}

	public function recycleExpiredPlatforms():List<Platform>
	{
		var expiredPlatforms:List<Platform> = new List<Platform>();

		for (platform in _platforms)
		{
			if (platform.pendingRecycle || platform.y >= _stageHeight)
			{
				expiredPlatforms.add(platform);
				_layer.removeChild(platform);
				
				platform.recycleFinished();
			}
			else
			{
				break;
			}
		}

		for (platform in expiredPlatforms)
		{
			recyclePlatform(platform);
		}

		return expiredPlatforms;
	}

	public function recyclePlatform(platform:Platform):Void
	{
		platform.y = _platforms[MAX_NUMBER_OF_PLATFORMS-1].y;
		platform.y -= getNewPlatformOffest_Y();

		platform.x = getNewPlatformOffest_X();

		_platforms.remove(platform);
		_platforms.push(platform);
	}

	public function updatePlatformsHorizontalPosition(horizontalChange:Float):Void
	{
		for (platform in _platforms)
		{
			platform.y += horizontalChange;
		}
	}
}