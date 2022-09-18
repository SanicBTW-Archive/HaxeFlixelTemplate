package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import lime.app.Future;
import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.system.System;
import openfl.utils.Assets;

// based off 0.5.2h mem management, modified to fit some stuff
class AssetPaths
{
	public static var imgsDone:Int = 0;
	public static var imgsToBeDone:Int = 0;
	public static var sndsDone:Int = 0;
	public static var sndsToBeDone:Int = 0;

	public static function clearUnusedMemory()
	{
		for (key in currentTrackedAssets.keys())
		{
			if (!localTrackedAssets.contains(key))
			{
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null)
				{
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		System.gc();
	}

	public static var localTrackedAssets:Array<String> = [];

	public static function clearStoredMemory(?cleanUnused:Bool = false)
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		for (key in currentTrackedSounds.keys())
		{
			if (!localTrackedAssets.contains(key) && key != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
		localTrackedAssets = [];
	}

	inline static public function image(key:String):FlxGraphic
	{
		var returnAsset:FlxGraphic = null;

		var path = 'assets/images/$key';

		if (currentTrackedAssets.exists(key) && !currentTrackedAssets.exists(path))
		{
			returnAsset = currentTrackedAssets.get(key);
		}
		else if (!currentTrackedAssets.exists(key))
		{
			returnAsset = returnGraphic(path);
		}

		return returnAsset;
	}

	inline static public function sound(key:String, ?folder:String = "sounds"):Sound
	{
		var returnAsset:Sound = null;

		var path = 'assets/$folder/$key';

		if (currentTrackedSounds.exists(key) && !currentTrackedSounds.exists(path))
		{
			returnAsset = currentTrackedSounds.get(key);
		}
		else if (!currentTrackedSounds.exists(key))
		{
			returnAsset = returnSound(key, folder);
		}

		return returnAsset;
	}

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

	public static function returnGraphic(key:String)
	{
		var path = 'assets/images/$key';
		if (Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				currentTrackedAssets.set(path, newGraphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}
		trace('returning null');
		return null;
	}

	inline static public function precacheImage(key:String)
	{
		imgsToBeDone++;

		BitmapData.loadFromFile(key).then(function(bit)
		{
			if (!currentTrackedAssets.exists(key))
			{
				var newGraphic:FlxGraphic = FlxG.bitmap.add(FlxGraphic.fromBitmapData(bit, false, key), false, key);
				currentTrackedAssets.set(key, newGraphic);
			}
			localTrackedAssets.push(key);
			imgsDone++;

			return Future.withValue(bit);
		});
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];

	// dunno if ithis will work
	public static function returnSound(key:String, ?folder:String = 'sounds')
	{
		var path = 'assets/$folder/$key';
		if (!currentTrackedSounds.exists(path))
		{
			currentTrackedSounds.set(path, Assets.getSound(path));
		}
		localTrackedAssets.push(path);
		return currentTrackedSounds.get(path);
	}

	inline public static function precacheSound(key:String)
	{
		sndsToBeDone++;

		Sound.loadFromFile(key).then(function(sound)
		{
			if (!currentTrackedSounds.exists(key))
			{
				currentTrackedSounds.set(key, sound);
			}
			localTrackedAssets.push(key);
			sndsDone++;

			return Future.withValue(sound);
		});
	}
}
