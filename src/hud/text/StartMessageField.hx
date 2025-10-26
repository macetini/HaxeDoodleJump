package hud.text;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
	StartMessageField is responsible for displaying the initial start message in the game.
	It prompts the player to press the SPACE key to start the game.
**/
class StartMessageField extends TextField {
	public function new() {
		super();

		var messageFormat:TextFormat = new TextFormat("Verdana", 16, 0x191900, true);
		messageFormat.align = TextFormatAlign.CENTER;
		defaultTextFormat = messageFormat;

		selectable = false;
		mouseEnabled = false;
		autoSize = "center";

		text = "Press SPACE or Tap(Click) Screen to start!";
	}
}