package managers;

import items.Platform;
import openfl.display.Sprite;

/**
	PlatformManager is responsible for managing the platforms in the game.
	It handles the creation, recycling, and positioning of platforms.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class PlatformManager {
	static inline final MAX_NUMBER_OF_PLATFORMS:Int = 30;
	static inline final FLOOR_OFFSET:Int = 165;
	static inline final SOON_VISIBLE_OFFSET:UInt = 30;

	static inline final MINI_PLATFORM_VER_DISTANCE:Float = 25;
	static inline final MAX_PLATFORM_VER_DISTANCE:Float = 100;

	var stageHeight:Float;
	var stageWidth:Float;

	var platforms:Array<Platform>;

	var layer:Sprite;

	public function new(layer:Sprite) {
		this.layer = layer;

		stageHeight = layer.stage.stageHeight;
		stageWidth = layer.stage.stageWidth;

		createPlatforms();
	}

	function createPlatforms() {
		platforms = [];

		var newPlatform:Platform;

		var lastPlatformY:Float = 0.0;

		for (i in 0...MAX_NUMBER_OF_PLATFORMS) {
			newPlatform = new Platform();
			newPlatform.y = lastPlatformY;

			lastPlatformY -= getNewY();

			platforms.push(newPlatform);
		}
	}

	/**
		Adds the platforms to the game layer.
		This method is called to initialize the platforms when the game starts.
	**/
	public function addPlatforms() {
		var visiblePlatforms:List<Platform> = getVisiblePlatforms();

		for (platform in visiblePlatforms) {
			layer.addChild(platform);
		}

		adjustPlatformsInitPos();
	}

	function getNewY():Float {
		return Platform.HEIGHT + (MAX_PLATFORM_VER_DISTANCE * Math.random()) + MINI_PLATFORM_VER_DISTANCE;
	}

	function getNewX():Float {
		return (stageWidth - Platform.WIDTH) * Math.random();
	}

	/**
		Adjusts the initial position of the platforms.
		This method is called to set the platforms' positions when they are added to the game layer.
	**/
	public function adjustPlatformsInitPos() {
		for (platform in platforms) {
			platform.y += stageHeight - FLOOR_OFFSET;
			platform.x = getNewX();
		}
	}

	/**
	Adds soon visible platforms to the game layer.
	This method is called to ensure that platforms that are about to become visible are added
	**/
	public function addSoonVisiblePlatforms() {
		var soonVisible:List<Platform> = getSoonVisible();

		for (platform in soonVisible) {
			layer.addChild(platform);
		}
	}

	/**
		Returns a list of platforms that are currently visible on the stage.
		These platforms are within the stage height and have not been recycled.
	
		@return List<Platform> A list of currently visible platforms.
	**/
	public function getVisiblePlatforms():List<Platform> {
		var visiblePlatforms:List<Platform> = new List<Platform>();
		var lowBorder:Float;

		for (platform in platforms) {
			lowBorder = platform.y;

			if (platform.y >= 0 && platform.y <= stageHeight) {
				visiblePlatforms.add(platform);
			}
			else {
				break;
			}
		}
		return visiblePlatforms;
	}

	/**
		Returns a list of platforms that are soon visible.
		These platforms are within the stage height plus a small offset.
	
		@return List<Platform> A list of soon visible platforms.
	**/
	public function getSoonVisible():List<Platform> {
		var soonVisiblePlatforms:List<Platform> = new List<Platform>();

		for (platform in platforms) {
			if (platform.y + Platform.HEIGHT <= stageHeight + SOON_VISIBLE_OFFSET) {
				soonVisiblePlatforms.add(platform);
			}
			else {
				break;
			}
		}

		return soonVisiblePlatforms;
	}

	/**
		Returns the last boostable platform that does not have a boost.
		This method is used to find a platform where a boost can be added.	

		@return Platform|null The last boostable platform or null if none found.	
	**/
	public function returnLastBoostablePlatform():Platform {
		var retPlatform:Platform;

		var i = platforms.length;
		while (--i >= 0) {
			retPlatform = platforms[i];

			if (retPlatform.normal && !retPlatform.hasBoost) {
				return retPlatform;
			}
		}
		return null;
	}

	/**
		Recycles expired platforms by removing them from the layer and resetting their position.
		Returns a list of recycled platforms.	
		@return List<Platform> A list of platforms that have been recycled.	
	**/
	public function recycleExpiredPlatforms():List<Platform> {
		var expiredPlatforms:List<Platform> = new List<Platform>();

		for (platform in platforms) {
			if (platform.pendingRecycle || platform.y >= stageHeight) {
				expiredPlatforms.add(platform);
				layer.removeChild(platform);
				platform.recycleFinished();
			}
			else {
				break;
			}
		}

		for (platform in expiredPlatforms) {
			recyclePlatform(platform);
		}

		return expiredPlatforms;
	}

	/**
		Recycles the platform by resetting its position and adding it to the end of the platforms list.
		This method is called when a platform goes out of view and needs to be reused.

		@param platform The platform to recycle.	
	**/
	public function recyclePlatform(platform:Platform) {
		platform.y = platforms[MAX_NUMBER_OF_PLATFORMS - 1].y;
		platform.y -= getNewY();

		platform.x = getNewX();

		platforms.remove(platform);
		platforms.push(platform);
	}

	/**
		Updates the horizontal position of all platforms based on the horizontal change.
		This method is called to adjust the platforms' positions when the hero moves horizontally.

		@param horizontalChange The amount of horizontal change to apply to each platform.
	**/
	public function updatePlatformsHorizontalPosition(horizontalChange:Float) {
		for (platform in platforms) {
			platform.y += horizontalChange;
		}
	}
}