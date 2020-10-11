package managers;
import items.Platform;
import openfl.display.Sprite;
import spawn.Boost;
import spawn.Fly;
import spawn.SpawnItem;

/**
 * ...
 * @author J.C. Denton
 */

class SpawnManager
{
	private var _spawnTypes:Array<Dynamic> = [Boost, Fly];

	private var _spawnPool:Map<String, Array<SpawnItem>>;

	private var _spawns:Array<SpawnItem>;

	private var _layer:Sprite;

	private var _stageHeight:Float;
	private var _stageWidth:Float;

	public function new(layer:Sprite)
	{
		_layer = layer;

		_stageHeight = layer.stage.stageHeight;
		_stageWidth = layer.stage.stageWidth;

		initSpawnPool();
	}

	private function initSpawnPool():Void
	{
		_spawns = new Array<SpawnItem>();
		_spawnPool = new Map<String, Array<SpawnItem>>();

		var typeClassName:String;

		for (spawnElem in _spawnTypes)
		{
			typeClassName = Type.getClassName(spawnElem);
			_spawnPool[typeClassName] = new Array<SpawnItem>();
		}
	}

	/**
	*
	* Entity timout update. If entity has defined Timeout than it cant be spawned until timeout has finished.
	*
	* @param elapsed Elapsed time since the last frame.
	*/

	public function updateTimeOut(elapsed:Float):Void
	{
		for (spawnElem in _spawnTypes)
		{
			if (spawnElem.TimeOutCounter > 0)
			{
				spawnElem.TimeOutCounter -= elapsed;
			}
		}
	}

	public function generateAndReturnSpawn():SpawnItem
	{
		return createSpawn(_spawnTypes);
	}

	/**
	*
	* Returne new spawn based on etities Weight. The higer the weight higher the chances of spawn.
	*
	* @param spawnArr Array of enteties.
	*/
	
	private function createSpawn(spawnArr:Array<Dynamic>):SpawnItem
	{
		var localSpawnArr:Array<Dynamic> = returnTimedOutSpawn(spawnArr);

		var total:Float = returnLocalSpawnTotal(localSpawnArr);

		if (total == 0)
		{
			return null;
		}

		var retElem:SpawnItem = createSpawnFromTotal(total, localSpawnArr);

		//trace(_spawnPool[Type.getClassName(Boost)].length + " - " +  _spawnPool[Type.getClassName(Fly)].length);

		return retElem;
	}

	private function returnTimedOutSpawn(spawnArr:Array<Dynamic>):Array<Dynamic>
	{
		var retLocalSpawnArr:Array<Dynamic> = new Array<Dynamic>();

		for (spawnElemType in spawnArr)
		{
			if (spawnElemType.TimeOutCounter <= 0)
			{
				retLocalSpawnArr.push(spawnElemType);
				spawnElemType.TimeOutCounter = spawnElemType.TimeOut;
			}
		}

		return retLocalSpawnArr;
	}

	private function returnLocalSpawnTotal(localSpawnArr:Array<Dynamic>):Float
	{
		var retTotal:Float = 0.0;

		for (spawnElemType in localSpawnArr)
		{
			retTotal += spawnElemType.Weight;
		}

		return retTotal;
	}

	private function createSpawnFromTotal(total:Float, localSpawnArr:Array<Dynamic>):SpawnItem
	{
		var retNewSpawn:SpawnItem = null;

		var thresh:Float = Math.random() * total;		

		for (spawnElemType in localSpawnArr)
		{
			thresh -= spawnElemType.Weight;

			if (thresh <= 0)
			{
				retNewSpawn = createOrPoolSpawn(spawnElemType);
				break;
			}
		}

		return retNewSpawn;
	}

	private function createOrPoolSpawn(spawnElemType:Dynamic):SpawnItem
	{
		var retElem:SpawnItem = null;
		
		var typeClassName:String = Type.getClassName(spawnElemType);

		if (_spawnPool[typeClassName].length == 0)
		{
			retElem = Type.createInstance(spawnElemType, []);
			_spawns.push(retElem);
		}
		else
		{
			retElem = _spawnPool[typeClassName].pop();
		}

		retElem.active = true;
		
		return retElem;
	}

	public function addBoostSpawn(spawn:SpawnItem, boostablePlatform:Platform):Void
	{
		if (boostablePlatform != null)
		{
			setSpawnOnPlatform(boostablePlatform, spawn);
			_layer.addChild(spawn);
		}
		else
		{
			recycleSpawn(spawn);
		}
	}

	private function setSpawnOnPlatform(boostablePlatform:Platform, spawn:SpawnItem):Void
	{
										//Float - no bit shifting.
		spawn.x = boostablePlatform.x + boostablePlatform.width / 2 - spawn.width / 2;
		spawn.y = boostablePlatform.y - spawn.height;

		boostablePlatform.hasBoost = true;
	}

	public function addFlySpawn(spawn:SpawnItem):Void
	{
		_layer.addChild(spawn);
	}

	public function updateSpawnHorizontalPosition(horizontalChange:Float):Void
	{
		var activeSpawn:Array<SpawnItem> = getActiveSpawn();
		for (spawn in activeSpawn)
		{
			spawn.y += horizontalChange;
		}
	}

	public function recycleExpiredSpawn():Array<SpawnItem>
	{
		var expiredSpawn:Array<SpawnItem> = new Array<SpawnItem>();
		
		var activeSpawn:Array<SpawnItem> = getActiveSpawn();		
		for (spawn in activeSpawn)
		{
			if (spawn.pendingRecycle || spawn.y >= _stageHeight)
			{
				expiredSpawn.push(spawn);
				recycleSpawn(spawn);
			}
		}

		return expiredSpawn;
	}
	
	public function getActiveSpawn():Array<SpawnItem>
	{
		var activeSpawn:Array<SpawnItem> = new Array<SpawnItem>();

		for (spawn in _spawns)
		{
			if (spawn.active)
			{
				activeSpawn.push(spawn);
			}
		}

		return activeSpawn;
	}

	public function recycleSpawn(spawn:SpawnItem):Void
	{
		if (_layer.contains(spawn))
		{
			_layer.removeChild(spawn);
		}

		spawn.recycleFinished();

		poolSpawn(spawn);
	}

	private function poolSpawn(spawn:SpawnItem):Void
	{
		var type:Dynamic = Type.getClass(spawn);

		var typeClassName:String = 	Type.getClassName(type);

		_spawnPool[typeClassName].push(spawn);

		//trace(_spawnPool[Type.getClassName(Boost)].length + " - " +  _spawnPool[Type.getClassName(Fly)].length);
	}

}