package managers;

import items.Platform;
import openfl.display.Sprite;
import spawn.Boost;
import spawn.Fly;
import spawn.SpawnItem;

/**
	SpawnManager is responsible for managing the spawning of items in the game.
	It handles the creation, recycling, and positioning of spawn items such as Boost and Fly.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class SpawnManager {
	var spawnTypes:Array<Class<SpawnItem>>;
	var liveSpawn:Array<SpawnItem>;

	var spawnPool:Map<String, Array<SpawnItem>>;

	var layer:Sprite;
	var stageHeight:Float;
	var stageWidth:Float;

	public function new(layer:Sprite) {
		this.layer = layer;

		stageHeight = layer.stage.stageHeight;
		stageWidth = layer.stage.stageWidth;

		initSpawnPool();
	}

	function initSpawnPool() {
		spawnTypes = [Fly, Boost];
		liveSpawn = [];
		spawnPool = new Map<String, Array<SpawnItem>>();

		for (spawnElem in spawnTypes) {
			var typeClassName:String = Type.getClassName(spawnElem);
			spawnPool[typeClassName] = [];
		}
	}

	/**
		Entity timout update. If entity has defined Timeout than it cant be spawned until timeout has finished.
		This method updates the timeout for each spawn type based on the elapsed time since the last frame.

		@param elapsed Elapsed time since the last frame.
	**/
	public function updateTimeOut(elapsed:Float) {
		for (spawnType in spawnTypes) {
			var spawnEmptyItem:SpawnItem = Type.createEmptyInstance(spawnType);
			spawnEmptyItem.updateTimeOut(elapsed);
		}
	}

	/**
		Adds a new spawn item to the game.
		This method checks for available spawn items, resets their timeout, and returns the new spawn item.
		If no items are available, it returns null.

		@return SpawnItem The newly created spawn item or null if no items are available.
	**/
	public function getNewSpawnItem():SpawnItem {
		var timedOutSpawn:Array<SpawnItem> = returnTimedOutSpawnItems();

		var totalWeight:Float = getSpawnTotalWeight(timedOutSpawn);
		if (totalWeight == 0) {
			return null;
		}

		var newSpawnItem:SpawnItem = getSpawnItemByWeight(totalWeight, timedOutSpawn);
		return newSpawnItem;
	}

	function returnTimedOutSpawnItems():Array<SpawnItem> {
		var timedOutSpawn:Array<SpawnItem> = [];

		for (type in spawnTypes) {
			var spawnItem:SpawnItem = getSpawnItemFromPool(type);
			if (spawnItem.getTimeOutCounter() <= 0) {
				timedOutSpawn.push(spawnItem);
			}
		}
		return timedOutSpawn;
	}

	function restSpawnTimeOutCounter(timedOutSpawn:Array<SpawnItem>) {
		for (spawn in timedOutSpawn) {
			spawn.resetTimeOutCounter();
		}
	}

	function getSpawnTotalWeight(spawn:Array<SpawnItem>):Float {
		var totalWeight:Float = 0.0;
		for (spawnElem in spawn) {
			totalWeight += spawnElem.getSpawnWeight();
		}
		return totalWeight;
	}

	function getSpawnItemByWeight(totalWeight:Float, spawn:Array<SpawnItem>):SpawnItem {
		var weightThreshold:Float = Math.random() * totalWeight;
		for (spawnElem in spawn) {
			weightThreshold -= spawnElem.getSpawnWeight();
			if (weightThreshold <= 0) {
				return spawnElem;
			}
		}
		return null;
	}

	function getSpawnItemFromPool(spawnElemType:Class<SpawnItem>):SpawnItem {
		final typeClassName:String = Type.getClassName(spawnElemType);

		final itemFoundInPool:Bool = spawnPool[typeClassName].length == 0;

		var spawnItem:SpawnItem = itemFoundInPool ? Type.createInstance(spawnElemType, []) : spawnPool[typeClassName].pop();

		return spawnItem;
	}

	/**
		Adds a Boost spawn item to the game layer.
		This method is used to add a Boost spawn item to the game layer for rendering.

		@param spawnBoost The Boost spawn item to add.
		@param boostablePlatform The platform on which the Boost should be spawned.
	**/
	public function addBoostSpawn(spawnBoost:SpawnItem, boostablePlatform:Platform) {
		if (boostablePlatform != null) {
			setSpawnOnPlatform(boostablePlatform, spawnBoost);
			addSpawnItem(spawnBoost);
		}
		else {
			recycleSpawnItem(spawnBoost);
		}
	}

	function setSpawnOnPlatform(boostablePlatform:Platform, spawn:SpawnItem) {
		final value:Float = 0.5;
		spawn.x = boostablePlatform.x + boostablePlatform.width * value - spawn.width * value;
		spawn.y = boostablePlatform.y - spawn.height;

		boostablePlatform.hasBoost = true;
	}

	/**
		Updates the horizontal position of all active spawn items based on the hero's movement.
		This method adjusts the position of each spawn item to match the hero's horizontal change.

		@param horizontalChange The horizontal change in the hero's position.
	**/
	public function updateSpawnHorizontalPosition(horizontalChange:Float) {
		var activeSpawn:Array<SpawnItem> = getLiveSpawn();
		for (spawn in activeSpawn) {
			spawn.y += horizontalChange;
		}
	}

	/**
		Recycles expired spawn items.
		This method checks all active spawn items and recycles those that are marked for recycling or have moved out of the visible area.

		@return Array<SpawnItem> An array of recycled spawn items.
	**/
	public function recycleExpiredSpawn():Array<SpawnItem> {
		var expiredSpawn:Array<SpawnItem> = [];

		var activeSpawn:Array<SpawnItem> = getLiveSpawn();
		for (spawn in activeSpawn) {
			if (spawn.pendingRecycle || spawn.y >= stageHeight) {
				expiredSpawn.push(spawn);
				recycleSpawnItem(spawn);
			}
		}
		return expiredSpawn;
	}

	/**
		Gets all currently active spawn items.
		This method returns an array of all spawn items that are currently active in the game.

		@return Array<SpawnItem> An array of active spawn items.
	**/
	public function getLiveSpawn():Array<SpawnItem> {
		return liveSpawn;
	}

	/**
		Adds a fly spawn item to the game layer.
		This method is used to add a fly spawn item to the game layer for rendering.

		@param spawnItem The spawn item to add.
	**/
	public function addSpawnItem(spawnItem:SpawnItem) {
		layer.addChild(spawnItem);
		spawnItem.live = true;
		spawnItem.resetTimeOutCounter();
		liveSpawn.push(spawnItem);
	}

	/**
		Recycles a spawn item by removing it from the layer and resetting its state.
		This method is called when a spawn item is no longer needed or has been used.

		@param spawnItem The spawn item to recycle.
	**/
	public function recycleSpawnItem(spawnItem:SpawnItem) {
		if (layer.contains(spawnItem)) {
			layer.removeChild(spawnItem);
		}
		spawnItem.recycleFinished();
		liveSpawn.remove(spawnItem);
		poolSpawnItem(spawnItem);
	}

	function poolSpawnItem(spawnItem:SpawnItem) {
		var type:Class<SpawnItem> = Type.getClass(spawnItem);
		var typeClassName:String = Type.getClassName(type);
		spawnPool[typeClassName].push(spawnItem);
	}
}