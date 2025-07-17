package managers;

import hud.text.HeightInfoMessageField;
import hud.text.StartMessageField;
import openfl.display.Sprite;

/**
 HUDManager is responsible for managing the Heads-Up Display (HUD) elements in the game.
 It handles the display of messages and information such as the player's height.
 
 @version 1.0
 @date 2023-10-01	
 @author Marko Cettina
**/
class HUDManager {
	var stageHeight:Float;
	var stageWidth:Float;

	var layer:Sprite;

	var startMessageField:StartMessageField;
	var heightInfoMessageField:HeightInfoMessageField;

	var height:Float;

	public function new(layer:Sprite) {
		stageHeight = layer.stage.stageHeight;
		stageWidth = layer.stage.stageWidth;

		height = 0;
		this.layer = layer;

		initText();
	}

	function initText() {
		startMessageField = new StartMessageField();
		layer.addChild(startMessageField);

		heightInfoMessageField = new HeightInfoMessageField(layer);
		heightInfoMessageField.width = stageWidth;
		heightInfoMessageField.y = 30;
		layer.addChild(heightInfoMessageField);
	}

	/**
		Hides the initial text message displayed at the start of the game.
		This method is called when the game starts or when the player begins playing.
	**/
	public function hideInitText() {
		if (startMessageField.visible) {
			startMessageField.visible = false;
		}
	}

	function showInitText() {
		startMessageField.visible = true;
	}

	/**
		Updates the height information displayed in the HUD.
		This method is called to refresh the height information based on the hero's position.
		
		@param newHeight The new height value to display.
	**/
	public function updateHeight(newHeight:Float) {
		height = Math.floor(newHeight);
		heightInfoMessageField.updateHeight(height);
	}
}