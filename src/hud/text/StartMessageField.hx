package hud.text;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author J.C. Denton
 */
class StartMessageField extends TextField
{
	public function new() 
	{
		super();
		
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;
		
		width = 150;//stage.stageWidth;

		defaultTextFormat = messageFormat;
		selectable = false;
		
		text = "Press SPACE";
	}
}