package managers;
import items.Hero;
import openfl.display.Sprite;

/**
 * ...
 * @author J.C. Denton
 */
class HeroManager
{
	private var _stageHeight:Float;
	private var _stageWidth:Float;
	
	private var _layer:Sprite;
	
	private var _previusYPositon:Float;
	
	public var hero(default, null):Hero;
	public var horizontalChange(default, null):Float;

	public function new(layer:Sprite)
	{
		_layer = layer;
		
		_stageHeight = layer.stage.stageHeight;
		_stageWidth = layer.stage.stageWidth;
	}
	
	public function addHero():Void
	{
		hero = new items.Hero();

		//Float, so I can`t use bit shifting
		hero.x = _layer.stage.stageWidth / 2 - hero.width / 2;
		hero.y = _layer.stage.stageHeight - hero.height;

		_layer.addChild(hero);

		_previusYPositon = _layer.stage.stageHeight - hero.height;
	}
	
	public function updateHorizontalChange():Float
	{
		horizontalChange = _previusYPositon - hero.realY;
		_previusYPositon = hero.realY;
		
		return horizontalChange;
	}
}