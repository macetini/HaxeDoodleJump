package managers;
import hud.text.HeightInfoMessageField;
import hud.text.StartMessageField;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author J.C. Denton
 */
class HUDManager
{
	private var _stageHeight:Float;
	private var _stageWidth:Float;
	
	private var _layer:Sprite;
	
	private var _startMessageField:StartMessageField;
	private var _heightInfoMessageField:HeightInfoMessageField;
	
	private var _height:Float = 0;
	
	public function new(layer:Sprite)
	{
		_layer = layer;

		_stageHeight = layer.stage.stageHeight;
		_stageWidth = layer.stage.stageWidth;
		
		initText();
	}
		
	private function initText():Void
	{
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;		
		
		_startMessageField = new StartMessageField();
		_layer.addChild(_startMessageField);
		
		_heightInfoMessageField = new HeightInfoMessageField(_layer);
		_heightInfoMessageField.width = _stageWidth;
		_heightInfoMessageField.y = 30;		
		_layer.addChild(_heightInfoMessageField);
	}
	
	public function hideInitText():Void
	{
		if (_startMessageField.visible)
		{
			_startMessageField.visible = false;
		}
	}
		
	public function showInitText():Void
	{
		_startMessageField.visible = true;
	}
	
	public function updateHeight(newHeight:Float):Void
	{		
		_height = Math.floor(newHeight);		
		_heightInfoMessageField.updateHeight(_height);
	}	
}