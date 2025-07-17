package managers;

import items.Hero;
import openfl.display.Sprite;

/**
	HeroManager is responsible for managing the hero character in the game.
	It handles the hero's position and movement.	

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class HeroManager {
	var stageHeight:Float;
	var stageWidth:Float;
	var layer:Sprite;
	var previusYPositon:Float;

	/**
		The hero object that is managed by this HeroManager.
		It is created and added to the game layer when the game starts.
	**/
	public var hero(default, null):Hero;

	/**
		The horizontal change in the hero's position.
		This is used to adjust the game view based on the hero's movement.
	**/
	public var horizontalChange(default, null):Float;

	public function new(layer:Sprite) {
		this.layer = layer;

		stageHeight = layer.stage.stageHeight;
		stageWidth = layer.stage.stageWidth;
	}

	/**
		Creates and adds the hero to the game layer.
		If the hero already exists, it does nothing.
	**/
	public function addHero() {
		if (hero != null) {
			return; // Hero already exists
		}

		horizontalChange = 0.0;
		previusYPositon = layer.stage.stageHeight - 100; // Initial position at the bottom of the stage

		createHero();
	}

	function createHero() {
		hero = new items.Hero();

		final value = 2;
		hero.x = layer.stage.stageWidth / value - hero.width / value;
		hero.y = layer.stage.stageHeight - hero.height;

		layer.addChild(hero);

		previusYPositon = layer.stage.stageHeight - hero.height;
	}

	/**
		Updates the horizontal change based on the hero's current position.
		@return Float
	**/
	public function updateHorizontalChange():Float {
		horizontalChange = previusYPositon - hero.realY;
		previusYPositon = hero.realY;

		return horizontalChange;
	}
}