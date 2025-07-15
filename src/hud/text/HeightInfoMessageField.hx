package hud.text;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author J.C. Denton
 */
class HeightInfoMessageField extends TextField
{
	public function new(layer:Sprite) 
	{
		super();

		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;

		defaultTextFormat = messageFormat;
		selectable = false;
		
		text = "Height: 0";
	}

	public function updateHeight(height:Float):Void
	{
		text = "Height: " + height;
	}
	
}