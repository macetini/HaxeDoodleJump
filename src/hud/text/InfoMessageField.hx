package hud.text;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author 
 */
class InfoMessageField extends TextField
{

	public function new() 
	{
		super();
		
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;
		
		//width = stage.stageWidth;
		
		//y = stage.stageHeight >> 2;
		defaultTextFormat = messageFormat;
		selectable = false;
		
		text = "Press SPACE";
	}
	
}