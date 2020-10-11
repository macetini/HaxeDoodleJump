package managers;

import flash.geom.Rectangle;
import items.Hero;
import items.Platform;
import spawn.Boost;
import spawn.Fly;
import spawn.SpawnItem;

/**
 * ...
 * @author J.C. Denton
 */
class CollisionManager
{
	public static inline var HERO_COALISION_PERCENTAGE:Float = 0.85;
	public static inline var PLATFORM_COALISION_PERCENTAGE:Float = 0.25;

	private var _heroLowBorder:Float;
	private var _heroHighBorder:Float;

	private var _platformLowBorder:Float;

	public function new()
	{
		calculateBorders();
	}

	private function calculateBorders():Void
	{
		_heroLowBorder = (Hero.RADIUS << 1) * HERO_COALISION_PERCENTAGE;
		_heroHighBorder = (Hero.RADIUS << 1) * (1 - HERO_COALISION_PERCENTAGE);

		_platformLowBorder = Platform.HEIGHT * PLATFORM_COALISION_PERCENTAGE;
	}

	public function checkCollidingWithSpawn(hero:Hero, activeSpawn:Array<SpawnItem>):Bool
	{
		for (spawn in activeSpawn)
		{
			if (Std.is(spawn, Fly) && isCollidingWithSpawn(hero, spawn))
			{
				hero.die();
				spawn.recycle();

				return true;
			}
		}

		return false;
	}

	public function isCollidingWithSpawn(hero:Hero, spawn:SpawnItem):Bool
	{
		var heroRect:Rectangle = new Rectangle(hero.x, hero.y, hero.width, hero.height);
		var spawnRect:Rectangle = new Rectangle(spawn.x, spawn.y, spawn.width, spawn.height);

		return heroRect.intersects(spawnRect);
	}

	public function checkCollidingWithBoost(hero:Hero, activeSpawn:Array<SpawnItem>):Bool
	{
		for (spawn in activeSpawn)
		{
			if (Std.is(spawn, Boost) && isCollidingWithBoost(hero, spawn))
			{
				hero.activateSuperJump();
				spawn.recycle();

				return true;
			}
		}

		return false;
	}

	public function isCollidingWithBoost(hero:Hero, spwan:SpawnItem):Bool
	{
		var heroRect:Rectangle = new Rectangle(hero.x, hero.y + _heroLowBorder, hero.width, _platformLowBorder);
		var boostRect:Rectangle = new Rectangle(spwan.x, spwan.y, spwan.width, spwan.height);

		return heroRect.intersects(boostRect);
	}

	public function checkCollidingWithPlatform(hero:Hero, visiblePlaforms:List<Platform>):Bool
	{
		for (platform in visiblePlaforms)
		{
			if (isCollidingWithPlaform(hero, platform))
			{
				if (platform.breakable)
				{
					platform.recycle();
				}
				else
				{
					hero.startJump();
					return true;
				}

				break;
			}
		}

		return false;
	}

	public function isCollidingWithPlaform(hero:Hero, platform:Platform):Bool
	{
		var heroRect:Rectangle = new Rectangle(hero.x, hero.y + _heroLowBorder, hero.width, _heroHighBorder);
		var platformRect:Rectangle = new Rectangle(platform.x, platform.y, platform.width, _platformLowBorder);

		return heroRect.intersects(platformRect);
	}
}