package managers;

import flash.geom.Rectangle;
import items.Hero;
import items.Platform;
import spawn.Boost;
import spawn.Fly;
import spawn.SpawnItem;

/**
	CollisionManager is responsible for handling collisions between game entities.
	It checks for collisions between the hero and spawn items, platforms, and boosts,
	and manages the logic for what happens when collisions occur.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class CollisionManager {
	static inline final HERO_COALISION_PERCENTAGE:Float = 0.85;
	static inline final PLATFORM_COALISION_PERCENTAGE:Float = 0.25;

	var heroLowBorder:Float;
	var heroHighBorder:Float;

	var platformLowBorder:Float;

	public function new() {
		calculateBorders();
	}

	function calculateBorders() {
		heroLowBorder = (Hero.RADIUS << 1) * HERO_COALISION_PERCENTAGE;
		heroHighBorder = (Hero.RADIUS << 1) * (1 - HERO_COALISION_PERCENTAGE);

		platformLowBorder = Platform.HEIGHT * PLATFORM_COALISION_PERCENTAGE;
	}

	/**
		Checks if the hero is colliding with any spawn items.
		If a collision is detected, it handles the interaction based on the type of spawn item.

		@param hero The hero object to check for collisions.
		@param spawnItems An array of currently active spawn items.
		@return True if a collision with a spawn item is detected, false otherwise.
	**/
	public function checkCollidingWithSpawn(hero:Hero, spawnItems:Array<SpawnItem>):Bool {
		for (spawnItem in spawnItems) {
			if (Std.is(spawnItem, Fly) && isCollidingWithSpawn(hero, spawnItem)) {
				hero.die();
				spawnItem.recycle();
				return true;
			}
		}
		return false;
	}

	/**
		Checks if the hero is colliding with a specific spawn item.
		This method uses rectangles to determine if the hero's bounding box intersects with the spawn item's bounding box.

		@param hero The hero object to check for collisions.
		@param spawn The spawn item to check for collisions against the hero.
		@return True if a collision is detected, false otherwise.
	**/
	public function isCollidingWithSpawn(hero:Hero, spawn:SpawnItem):Bool {
		var heroRect:Rectangle = new Rectangle(hero.x, hero.y, hero.width, hero.height);
		var spawnRect:Rectangle = new Rectangle(spawn.x, spawn.y, spawn.width, spawn.height);

		return heroRect.intersects(spawnRect);
	}

	/**
		Checks if the hero is colliding with a boost item.
		If a collision is detected, it activates the boost for the hero and recycles the spawn item.

		@param hero The hero object to check for collisions.
		@param activeSpawn An array of currently active spawn items.
		@return True if a collision with a boost is detected, false otherwise.
	**/
	public function checkCollidingWithBoost(hero:Hero, activeSpawn:Array<SpawnItem>):Bool {
		for (spawnItem in activeSpawn) {
			if (Std.is(spawnItem, Boost) && isCollidingWithBoost(hero, spawnItem)) {
				hero.activateSuperJump();
				spawnItem.recycle();

				return true;
			}
		}

		return false;
	}

	/**
		Checks if the hero is colliding with a boost item.
		This method uses rectangles to determine if the hero's bounding box intersects with the boost item's bounding box.

		@param hero The hero object to check for collisions.
		@param spwan The spawn item representing the boost.
		@return True if a collision is detected, false otherwise.
	**/
	public function isCollidingWithBoost(hero:Hero, spwan:SpawnItem):Bool {
		var heroRect:Rectangle = new Rectangle(hero.x, hero.y + heroLowBorder, hero.width, platformLowBorder);
		var boostRect:Rectangle = new Rectangle(spwan.x, spwan.y, spwan.width, spwan.height);

		return heroRect.intersects(boostRect);
	}

	/**
		Checks if the hero is colliding with any visible platforms.
		If a collision is detected, it handles the interaction based on the type of platform.

		@param hero The hero object to check for collisions.
		@param visiblePlaforms A list of currently visible platforms.
		@return True if a collision is detected, false otherwise.
	**/
	public function checkCollidingWithPlatform(hero:Hero, visiblePlaforms:List<Platform>):Bool {
		for (platform in visiblePlaforms) {
			if (isCollidingWithPlaform(hero, platform)) {
				if (platform.breakable) {
					platform.recycle();
				}
				else {
					hero.startJump();
					return true;
				}

				break;
			}
		}
		return false;
	}

	/**
		Checks if the hero is colliding with a specific platform.
		This method uses rectangles to determine if the hero's bounding box intersects with the platform's bounding box.

		@param hero The hero object to check for collisions.
		@param platform The platform to check for collisions against the hero.
		@return True if a collision is detected, false otherwise.
	**/
	public function isCollidingWithPlaform(hero:Hero, platform:Platform):Bool {
		var heroRect:Rectangle = new Rectangle(hero.x, hero.y + heroLowBorder, hero.width, heroHighBorder);
		var platformRect:Rectangle = new Rectangle(platform.x, platform.y, platform.width, platformLowBorder);

		return heroRect.intersects(platformRect);
	}
}