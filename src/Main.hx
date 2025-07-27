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
Main class is the entry point of the Doodle Jump game.
It initializes the game layers, managers, and handles the main game loop.

@version 1.0
@date 2023-10-01
@author Marko Cettina
**/
class Main extends GameItem {
	var platformsLayer:Sprite;
	var spawnsLayer:Sprite;
	var heroLayer:Sprite;
	var hudLayer:Sprite;

	var platformManager:PlatformManager;
	var spawnManager:SpawnManager;
	var heroManager:HeroManager;
	var hudManager:HUDManager;

	var collisionManager:CollisionManager;
	var difficultyManager:DifficultyManager;

	public function new() {
		super();
	}

	override public function addedToStage(event:Event) {
		super.addedToStage(event);

		createAndAddLayers();
		createManagers();
		addPlatforms();
		addHero();
	}

	function createAndAddLayers() {
		platformsLayer = addNewLayer();
		spawnsLayer = addNewLayer();
		heroLayer = addNewLayer();
		hudLayer = addNewLayer();
	}

	function addNewLayer():Sprite {
		var newLayer:Sprite = new Sprite();
		this.addChild(newLayer);

		return newLayer;
	}

	function createManagers() {
		platformManager = new PlatformManager(platformsLayer);
		spawnManager = new SpawnManager(spawnsLayer);
		heroManager = new HeroManager(heroLayer);
		hudManager = new HUDManager(hudLayer);

		collisionManager = new CollisionManager();
		difficultyManager = new DifficultyManager();
	}

	function addPlatforms() {
		platformManager.addPlatforms();
	}

	function addHero() {
		heroManager.addHero();
	}

	override public function update(deltaTime:Float) {
		recycleExpiredItems();

		generateSpawn(deltaTime);

		checkCollision();

		updateHorizontalChange();

		updateHud();

		addSoonVisiblePlatforms();
	}

	function recycleExpiredItems() {
		platformManager.recycleExpiredPlatforms();
		spawnManager.recycleExpiredSpawn();
	}

	function generateSpawn(deltaTime:Float) {
		spawnManager.updateTimeOut(deltaTime);

		var newSpawn:SpawnItem = spawnManager.getNewSpawnItem();

		if (newSpawn != null) {
			if (Std.is(newSpawn, Boost)) {
				var boostablePlatform:Platform = platformManager.returnLastBoostablePlatform();
				spawnManager.addBoostSpawn(newSpawn, boostablePlatform);
				return;
			}

			if (Std.is(newSpawn, Fly)) {
				spawnManager.addSpawnItem(newSpawn);
				return;
			}
		}
	}

	function checkCollision() {
		var liveSpawnItems:Array<SpawnItem> = spawnManager.getLiveSpawn();
		var hero:Hero = heroManager.hero;

		var isColliding:Bool = collisionManager.checkCollidingWithSpawn(hero, liveSpawnItems);

		if (isColliding) {
			return;
		}

		if (heroManager.horizontalChange <= 0) {
			isColliding = collisionManager.checkCollidingWithBoost(hero, liveSpawnItems);
			if (isColliding) {
				return;
			}

			var visiblePlatforms:List<Platform> = platformManager.getVisiblePlatforms();
			isColliding = collisionManager.checkCollidingWithPlatform(hero, visiblePlatforms);

			if (isColliding) {
				return;
			}
		}
	}

	function updateHorizontalChange() {
		var newHorizontalChange:Float = heroManager.updateHorizontalChange();

		if (newHorizontalChange > 0) {
			platformManager.updatePlatformsHorizontalPosition(newHorizontalChange);
			spawnManager.updateSpawnHorizontalPosition(newHorizontalChange);

			var newHeight:Float = difficultyManager.increaseHeight(newHorizontalChange);

			hudManager.updateHeight(newHeight);
		}
	}

	function updateHud() {
		var horizontalChange:Float = heroManager.horizontalChange;

		if (horizontalChange != 0) {
			hudManager.hideInitText();
		}
	}

	function addSoonVisiblePlatforms() {
		platformManager.addSoonVisiblePlatforms();
	}
}