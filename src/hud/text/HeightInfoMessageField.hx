package hud.text;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
	HeightInfoMessageField is responsible for displaying the height information in the game.
	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class HeightInfoMessageField extends TextField {
	public function new(layer:Sprite) {
		super();

		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;

		defaultTextFormat = messageFormat;
		selectable = false;
		mouseEnabled = false;
		autoSize = "center";
		//text = "Height: 0";
	}

	/**
		Updates the height information displayed in the text field. 
		@param height The new height value to display.
	**/
	public function updateHeight(height:Float) {
		if (height < 0) {
			height = 0;
		}
		text = "Height: " + height;
	}
}