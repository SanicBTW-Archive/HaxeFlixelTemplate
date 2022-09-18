package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Future;
import openfl.display.BitmapData;
import openfl.utils.Assets;

class Startup extends FlxState
{
	var bg:FlxSprite;
	var loading:FlxText;

	// shit can precache online images and even asset images
	public static var precacheList:Array<String> = [
		'https://media.discordapp.net/attachments/907738207528050718/1020080809056669736/Img_2022_09_15_14_57_53.jpg',
		'assets/images/dumbfairy.jpeg',
		'https://media.discordapp.net/attachments/907738207528050718/1020066776760995971/unknown.png',
		'https://media.discordapp.net/attachments/907738207528050718/1020068815863824473/unknown.png'
	];

	override function create()
	{
		FlxG.save.bind("funkySave", "sanicbtw");
		SaveData.initSettings();

		FlxG.keys.preventDefaultKeys = [TAB];
		FlxG.game.focusLostFramerate = 30;

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		bg.screenCenter();
		add(bg);

		loading = new FlxText(0, 0, 0, "Loading...", 22);
		loading.setFormat("_sans", 22, FlxColor.WHITE, LEFT);
		loading.screenCenter();
		add(loading);

		for (i in 0...precacheList.length)
		{
			AssetPaths.precacheImage(precacheList[i]);
		}

		AssetPaths.precacheSound('http://sancopublic.ddns.net:5430/api/files/music/G8msGX73o6R2boG/aBV8wpElV40IjTjqOodof3rxy5mawC3z.mp3');

		super.create();
	}

	override function update(elapsed:Float)
	{
		var shitDone = AssetPaths.imgsDone + AssetPaths.sndsDone;
		var shitToBeDone = AssetPaths.imgsToBeDone + AssetPaths.sndsToBeDone;

		if (shitDone != shitToBeDone)
		{
			loading.text = shitToBeDone - shitDone + " assets left";
		}

		if (shitDone == shitToBeDone)
		{
			loading.text = "Done!";
		}

		if (loading.text == "Done!")
		{
			new FlxTimer().start(1.5, (twn:FlxTimer) -> FlxG.switchState(new PlayState()));
		}
		super.update(elapsed);
	}
}
