package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280;
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = Startup;
	var zoom:Float = -1;
	var framerate:Int = 60;
	var skipSplash:Bool = false;
	var startFullscreen:Bool = false;

	public static var fpsOverlay:FPS;
	public static var memoryOverlay:MemoryCounter;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		FlxGraphic.defaultPersist = true;

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		fpsOverlay = new FPS(10, 8, 0xFFFFFF);
		addChild(fpsOverlay);
		if (fpsOverlay != null)
		{
			fpsOverlay.visible = FlxG.save.data.showFPS;
		}

		memoryOverlay = new MemoryCounter(10, 20);
		addChild(memoryOverlay);
		if (memoryOverlay != null)
		{
			memoryOverlay = FlxG.save.data.showMemory;
		}

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
	}
}
