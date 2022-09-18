package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var exampleSprite:FlxSprite;
	var goofysound:FlxSound;

	override public function create()
	{
		exampleSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		exampleSprite.screenCenter();
		add(exampleSprite);

		goofysound = new FlxSound();
		goofysound.loadEmbedded(AssetPaths.sound("http://sancopublic.ddns.net:5430/api/files/music/G8msGX73o6R2boG/aBV8wpElV40IjTjqOodof3rxy5mawC3z.mp3"));
		FlxG.sound.list.add(goofysound);
		goofysound.play();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ONE)
		{
			exampleSprite.loadGraphic(AssetPaths.image(Startup.precacheList[0]));
		}
		if (FlxG.keys.justPressed.TWO)
		{
			exampleSprite.loadGraphic(AssetPaths.image(Startup.precacheList[1]));
		}
		if (FlxG.keys.justPressed.THREE)
		{
			exampleSprite.loadGraphic(AssetPaths.image(Startup.precacheList[2]));
		}
		if (FlxG.keys.justPressed.FOUR)
		{
			exampleSprite.loadGraphic(AssetPaths.image(Startup.precacheList[3]));
		}

		super.update(elapsed);
	}
}
