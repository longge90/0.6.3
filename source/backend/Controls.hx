package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;
#if mobile
import mobile.flixel.FlxVirtualPad;
#end

class Controls
{
	//Keeping same use cases on stuff for it to be easier to understand/use
	//I'd have removed it but this makes it a lot less annoying to use in my opinion

	//You do NOT have to create these variables/getters for adding new keys,
	//but you will instead have to use:
	//   controls.justPressed("ui_up")   instead of   controls.UI_UP

	//Dumb but easily usable code, or Smart but complicated? Your choice.
	//Also idk how to use macros they're weird as fuck lol

	// Pressed buttons (directions)
	public var UI_UP_P(get, never):Bool;
	public var UI_DOWN_P(get, never):Bool;
	public var UI_LEFT_P(get, never):Bool;
	public var UI_RIGHT_P(get, never):Bool;
	public var NOTE_UP_P(get, never):Bool;
	public var NOTE_DOWN_P(get, never):Bool;
	public var NOTE_LEFT_P(get, never):Bool;
	public var NOTE_RIGHT_P(get, never):Bool;
	private function get_UI_UP_P() return justPressed('ui_up');
	private function get_UI_DOWN_P() return justPressed('ui_down');
	private function get_UI_LEFT_P() return justPressed('ui_left');
	private function get_UI_RIGHT_P() return justPressed('ui_right');
	private function get_NOTE_UP_P() return justPressed('note_up');
	private function get_NOTE_DOWN_P() return justPressed('note_down');
	private function get_NOTE_LEFT_P() return justPressed('note_left');
	private function get_NOTE_RIGHT_P() return justPressed('note_right');

	// Held buttons (directions)
	public var UI_UP(get, never):Bool;
	public var UI_DOWN(get, never):Bool;
	public var UI_LEFT(get, never):Bool;
	public var UI_RIGHT(get, never):Bool;
	public var NOTE_UP(get, never):Bool;
	public var NOTE_DOWN(get, never):Bool;
	public var NOTE_LEFT(get, never):Bool;
	public var NOTE_RIGHT(get, never):Bool;
	private function get_UI_UP() return pressed('ui_up');
	private function get_UI_DOWN() return pressed('ui_down');
	private function get_UI_LEFT() return pressed('ui_left');
	private function get_UI_RIGHT() return pressed('ui_right');
	private function get_NOTE_UP() return pressed('note_up');
	private function get_NOTE_DOWN() return pressed('note_down');
	private function get_NOTE_LEFT() return pressed('note_left');
	private function get_NOTE_RIGHT() return pressed('note_right');

	// Released buttons (directions)
	public var UI_UP_R(get, never):Bool;
	public var UI_DOWN_R(get, never):Bool;
	public var UI_LEFT_R(get, never):Bool;
	public var UI_RIGHT_R(get, never):Bool;
	public var NOTE_UP_R(get, never):Bool;
	public var NOTE_DOWN_R(get, never):Bool;
	public var NOTE_LEFT_R(get, never):Bool;
	public var NOTE_RIGHT_R(get, never):Bool;
	private function get_UI_UP_R() return justReleased('ui_up');
	private function get_UI_DOWN_R() return justReleased('ui_down');
	private function get_UI_LEFT_R() return justReleased('ui_left');
	private function get_UI_RIGHT_R() return justReleased('ui_right');
	private function get_NOTE_UP_R() return justReleased('note_up');
	private function get_NOTE_DOWN_R() return justReleased('note_down');
	private function get_NOTE_LEFT_R() return justReleased('note_left');
	private function get_NOTE_RIGHT_R() return justReleased('note_right');


	// Pressed buttons (others)
	public var ACCEPT(get, never):Bool;
	public var BACK(get, never):Bool;
	public var PAUSE(get, never):Bool;
	public var RESET(get, never):Bool;
	private function get_ACCEPT() return justPressed('accept');
	private function get_BACK() return justPressed('back');
	private function get_PAUSE() return justPressed('pause');
	private function get_RESET() return justPressed('reset');

	//Gamepad & Keyboard stuff
	public var keyboardBinds:Map<String, Array<FlxKey>>;
	public var gamepadBinds:Map<String, Array<FlxGamepadInputID>>;
	public function justPressed(key:String)
	{
		var result:Bool = (FlxG.keys.anyJustPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true #if mobile || mobileControlsJustPressed(key) == true #end;
	}

	public function pressed(key:String)
	{
		var result:Bool = (FlxG.keys.anyPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadPressed(gamepadBinds[key]) == true #if mobile || mobileControlsPressed(key) == true #end;
	}

	public function justReleased(key:String)
	{
		var result:Bool = (FlxG.keys.anyJustReleased(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true #if mobile || mobileControlsJustReleased(key) == true #end;
	}

	public var controllerMode:Bool = false;
	private function _myGamepadJustPressed(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyJustPressed(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadPressed(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyPressed(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadJustReleased(keys:Array<FlxGamepadInputID>):Bool
	{
		if(keys != null)
		{
			for (key in keys)
			{
				if (FlxG.gamepads.anyJustReleased(key) == true)
				{
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}

	#if mobile
	public var substate:Bool = false;
	public var virtualpad:FlxVirtualPad;
	
	// Based on NF|beihu's code. -Idklool
	private function mobileControlsJustPressed(key:String):Bool
	{
		virtualpad = substate ? MusicBeatSubstate.instance.virtualPad : MusicBeatState.instance.virtualPad;
		controllerMode = true;
		if (virtualpad != null) {
			switch(key) {
				case 'accept':
					return virtualpad.buttonA.justPressed;
				case 'back':
					return virtualpad.buttonB.justPressed;
				case 'ui_up':
					return virtualpad.buttonUp.justPressed;
				case 'ui_down':
					return virtualpad.buttonDown.justPressed;
				case 'ui_left':
					return virtualpad.buttonLeft.justPressed;
				case 'ui_right':
					return virtualpad.buttonRight.justPressed;
			}
		}
		if ((mobile.MobileControls.mode.startsWith('Pad-')) && (mobile.MobileControls.mode != 'Hitbox' && mobile.MobileControls.mode != 'keyboard'))
			{
				switch(key) {
					case 'note_up':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonUp.justPressed || MusicBeatState.instance.mobileControls.virtualPad.buttonUp2.justPressed;
					case 'note_down':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonDown.justPressed || MusicBeatState.instance.mobileControls.virtualPad.buttonDown2.justPressed;
					case 'note_left':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonLeft.justPressed || MusicBeatState.instance.mobileControls.virtualPad.buttonLeft2.justPressed;
					case 'note_right':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonRight.justPressed || MusicBeatState.instance.mobileControls.virtualPad.buttonRight2.justPressed;
				}
			} else if (mobile.MobileControls.mode == 'Hitbox')
			{
				switch (key)
				{
					case 'note_up':
						return MusicBeatState.instance.mobileControls.hitbox.buttonUp.justPressed;
					case 'note_down':
						return MusicBeatState.instance.mobileControls.hitbox.buttonDown.justPressed;
					case 'note_left':
						return MusicBeatState.instance.mobileControls.hitbox.buttonLeft.justPressed;
					case 'note_right':
						return MusicBeatState.instance.mobileControls.hitbox.buttonRight.justPressed;
				}
			}
		return false;
	}
	
	private function mobileControlsPressed(key:String):Bool
	{
		virtualpad = substate ? MusicBeatSubstate.instance.virtualPad : MusicBeatState.instance.virtualPad;
		controllerMode = true;
		if (virtualpad != null) {
			switch(key) {
				case 'ui_up':
					return virtualpad.buttonUp.pressed;
				case 'ui_down':
					return virtualpad.buttonDown.pressed;
				case 'ui_left':
					return virtualpad.buttonLeft.pressed;
				case 'ui_right':
					return virtualpad.buttonRight.pressed;
			}
		}
		if ((mobile.MobileControls.mode.startsWith('Pad-')) && (mobile.MobileControls.mode != 'Hitbox' && mobile.MobileControls.mode != 'keyboard'))
			{
				switch(key) {
					case 'note_up':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonUp.pressed || MusicBeatState.instance.mobileControls.virtualPad.buttonUp2.pressed;
					case 'note_down':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonDown.pressed || MusicBeatState.instance.mobileControls.virtualPad.buttonDown2.pressed;
					case 'note_left':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonLeft.pressed || MusicBeatState.instance.mobileControls.virtualPad.buttonLeft2.pressed;
					case 'note_right':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonRight.pressed || MusicBeatState.instance.mobileControls.virtualPad.buttonRight2.pressed;
				}
			} else if (mobile.MobileControls.mode == 'Hitbox')
			{
				switch (key)
				{
					case 'note_up':
						return MusicBeatState.instance.mobileControls.hitbox.buttonUp.pressed;
					case 'note_down':
						return MusicBeatState.instance.mobileControls.hitbox.buttonDown.pressed;
					case 'note_left':
						return MusicBeatState.instance.mobileControls.hitbox.buttonLeft.pressed;
					case 'note_right':
						return MusicBeatState.instance.mobileControls.hitbox.buttonRight.pressed;
				}
			}
		return false;
	}
	
	private function mobileControlsJustReleased(key:String):Bool
	{
		virtualpad = substate ? MusicBeatSubstate.instance.virtualPad : MusicBeatState.instance.virtualPad;
		controllerMode = true;
		if (virtualpad != null) {
			switch(key) {
				case 'ui_up':
					return virtualpad.buttonUp.justReleased;
				case 'ui_down':
					return virtualpad.buttonDown.justReleased;
				case 'ui_left':
					return virtualpad.buttonLeft.justReleased;
				case 'ui_right':
					return virtualpad.buttonRight.justReleased;
			}
		}
		if ((mobile.MobileControls.mode.startsWith('Pad-')) && (mobile.MobileControls.mode != 'Hitbox' || mobile.MobileControls.mode != 'keyboard'))
			{
				switch(key) {
					case 'note_up':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonUp.justReleased || MusicBeatState.instance.mobileControls.virtualPad.buttonUp2.justReleased;
					case 'note_down':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonDown.justReleased || MusicBeatState.instance.mobileControls.virtualPad.buttonDown2.justReleased;
					case 'note_left':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonLeft.justReleased || MusicBeatState.instance.mobileControls.virtualPad.buttonLeft2.justReleased;
					case 'note_right':
						return MusicBeatState.instance.mobileControls.virtualPad.buttonRight.justReleased || MusicBeatState.instance.mobileControls.virtualPad.buttonRight2.justReleased;
				}
			} else if (mobile.MobileControls.mode == 'Hitbox')
			{
				switch (key)
				{
					case 'note_up':
						return MusicBeatState.instance.mobileControls.hitbox.buttonUp.justReleased;
					case 'note_down':
						return MusicBeatState.instance.mobileControls.hitbox.buttonDown.justReleased;
					case 'note_left':
						return MusicBeatState.instance.mobileControls.hitbox.buttonLeft.justReleased;
					case 'note_right':
						return MusicBeatState.instance.mobileControls.hitbox.buttonRight.justReleased;
				}
			}
		return false;
	}
	#end

	// IGNORE THESE
	public static var instance:Controls;
	public function new()
	{
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}
}
