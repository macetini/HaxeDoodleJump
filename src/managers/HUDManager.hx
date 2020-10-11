package managers;
import hud.text.InfoMessageField;
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
	
	private var _infoMessageField:TextField;
	private var _heightMessageField:TextField;
	
	private var _height:Float = 0;
	
	public function new(layer:Sprite)
	{
		_layer = layer;

		_stageHeight = layer.stage.stageHeight;
		_stageWidth = layer.stage.stageWidth;
		
		initText();
	}
	
	//TODO - REFACTOR - put text in seperate classes, organize it better
	private function initText():Void
	{
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;
		
		_infoMessageField = new TextField();		
		_infoMessageField.width = _layer.stage.stageWidth;
		_infoMessageField.y = _layer.stage.stageHeight >> 2;
		_infoMessageField.defaultTextFormat = messageFormat;
		_infoMessageField.selectable = false;
		_infoMessageField.text = "Press SPACE";
		
		//_layer.addChild(_infoMessageField);
		
		var infoMessageField:InfoMessageField = new InfoMessageField();
		_layer.addChild(infoMessageField);
		
		_heightMessageField = new TextField();		
		_heightMessageField.width = _layer.stage.stageWidth;
		_heightMessageField.y = 30;
		_heightMessageField.defaultTextFormat = messageFormat;
		_heightMessageField.selectable = false;
		_heightMessageField.text = "Height: " + _height;
		
		_layer.addChild(_heightMessageField);
	}
	
	public function hideInitText():Void
	{
		if (_infoMessageField.visible)
		{
			_infoMessageField.visible = false;
		}
	}
	
	//TODO - implement this
	public function showInitText():Void
	{
		_infoMessageField.visible = true;
	}
	
	public function updateHeight(newHeight:Float):Void
	{		
		_height = Math.floor(newHeight);
		
		_heightMessageField.text = "Height: " + _height;
	}	
}