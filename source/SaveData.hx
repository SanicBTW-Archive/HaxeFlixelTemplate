package;

import flixel.FlxG;

// My way to manage save data
class SaveData
{
	// Stores the settings in here, the setting name (key) and the default value of it
	public static var settings:Map<String, Dynamic> = new Map();

	// Init settings (basically add settings to the map) and the load them
	public static function initSettings()
	{
		settings["showFPS"] = true;
		settings["antialiasing"] = true;
		settings["showMemory"] = true;

		loadSettings();
	}

	// Loads all the settings using Reflect.getProp on FlxG.save.data
	public static function loadSettings()
	{
		for (settingName => defaultValue in settings)
		{
			var property = Reflect.getProperty(FlxG.save.data, settingName);
			settings.set(settingName, (property == null ? defaultValue : property));
		}
	}

	// Save settings using Reflect.setProp on FlxG.save.data at the setting name and value
	public static function saveSettings()
	{
		for (settingName => settingValue in settings)
		{
			Reflect.setProperty(FlxG.save.data, settingName, settingValue);
		}

		FlxG.save.flush();

		FlxG.log.add("Saved");
	}
}
