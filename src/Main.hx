package;

import flash.display.Sprite;
import flash.events.Event;
import items.GameItem;
import items.Hero;
import items.Platform;
import managers.CollisionManager;
import managers.DifficultyManager;
import managers.HUDManager;
import managers.HeroManager;
import managers.PlatformManager;
import managers.SpawnManager;
import spawn.Boost;
import spawn.Fly;
import spawn.SpawnItem;

/**
 * ...
 * @author J.C. Denton
 */
class Main extends GameItem
{
	private var _platformsLayer:Sprite;
	private var _spawnsLayer:Sprite;
	private var _heroLayer:Sprite;
	private var _HUDLayer:Sprite;
	
	private var _platformManager:PlatformManager;
	private var _spawnManager:SpawnManager;
	private var _heroManager:HeroManager;
	private var _HUDManager:HUDManager;
	
	private var _collisionManager:CollisionManager;
	private var _difficultyManager:DifficultyManager;

	public function new()
	{
		super();
	}

	override public function addedToStage(event:Event):Void
	{
		super.addedToStage(event);

		createAndAddLayers();

		createManagers();

		addPlatforms();

		addHero();
	}

	private function createAndAddLayers():Void
	{
		_platformsLayer = createLayer(_platformsLayer);
		_spawnsLayer = createLayer(_spawnsLayer);
		_heroLayer = createLayer(_heroLayer);
		_HUDLayer = createLayer(_HUDLayer);
	}

	private function createLayer(newLayer:Sprite):Sprite
	{
		newLayer = new Sprite();
		this.addChild(newLayer);

		return newLayer;
	}

	private function createManagers():Void
	{
		_platformManager = new PlatformManager(_platformsLayer);
		_spawnManager = new SpawnManager(_spawnsLayer);
		_heroManager = new HeroManager(_heroLayer);
		_HUDManager = new HUDManager(_HUDLayer);
		
		_collisionManager = new CollisionManager();
		_difficultyManager = new DifficultyManager();
	}

	private function addPlatforms():Void
	{
		_platformManager.addPlatforms();
	}
	
	private function addHero():Void
	{
		_heroManager.addHero();
	}

	override public function update(deltaTime:Float):Void
	{
		super.update(deltaTime);

		recycleExpiredItems();

		generateSpawn(deltaTime);
		
		checkCoallision();
		
		updateHorizontalChange();
		
		updateHud();
		
		addSoonVisiblePlatforms();		
	}
	
	private function recycleExpiredItems():Void
	{
		_platformManager.recycleExpiredPlatforms();
		_spawnManager.recycleExpiredSpawn();
	}

	private function generateSpawn(deltaTime:Float):Void
	{
		_spawnManager.updateTimeOut(deltaTime);
		
		var spawn:SpawnItem = _spawnManager.generateAndReturnSpawn();

		if (spawn != null)
		{
			if ( Std.is(spawn, Boost))
			{
				var boostablePlatform:Platform = _platformManager.returnLastBoostablePlatform();
				_spawnManager.addBoostSpawn(spawn, boostablePlatform);
				
				return;
			}

			if ( Std.is(spawn, Fly))
			{
				_spawnManager.addFlySpawn(spawn);
				return;
			}
		}
	}
	
	private function checkCoallision():Void
	{
		var activeSpawn:Array<SpawnItem> = _spawnManager.getActiveSpawn();
		var hero:Hero = _heroManager.hero;
		
		var isColliding:Bool = _collisionManager.checkCollidingWithSpawn(hero, activeSpawn);
		
		if (isColliding)
		{			
			return;
		}
		
		if (_heroManager.horizontalChange <= 0)
		{			
			isColliding  = _collisionManager.checkCollidingWithBoost(hero, activeSpawn);
			if (isColliding)
			{
				return;
			}
			
			var visiblePlaforms:List<Platform> = _platformManager.getVisiblePlaforms();			
			isColliding = _collisionManager.checkCollidingWithPlatform(hero, visiblePlaforms);
			
			if (isColliding)
			{
				return;
			}
		}
	}

	private function updateHorizontalChange():Void
	{
		var newHorizontalChange:Float = _heroManager.updateHorizontalChange();
		
		if (newHorizontalChange > 0)
		{
			_platformManager.updatePlatformsHorizontalPosition(newHorizontalChange);
			_spawnManager.updateSpawnHorizontalPosition(newHorizontalChange);
			
			var newHeight:Float = _difficultyManager.increaseHeight(newHorizontalChange);
			
			_HUDManager.updateHeight(newHeight);
		}
	}
	
	private function updateHud():Void
	{
		var horizontalChange:Float = _heroManager.horizontalChange;
		
		if (horizontalChange != 0)
		{
			_HUDManager.hideInitText();
		}
	}
	
	private function addSoonVisiblePlatforms():Void
	{
		_platformManager.addSoonVisiblePlatforms();
	}
}
