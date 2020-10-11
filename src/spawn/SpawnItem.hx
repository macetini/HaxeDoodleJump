package spawn;
import items.GameItem;

/**
 * ...
 * @author J.C. Denton
 */
class SpawnItem extends GameItem
{
	/**
	 * Activation flag
	 */
	public var active(default, default):Bool = false;
	
	override public function recycleFinished():Void
	{
		active = false;
		
		super.recycleFinished();		
	}
	
	public function new() 
	{
		super();
	}
	
}