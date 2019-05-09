package;

import haxe.io.Bytes;
import haxe.network.TcpConnection;
import haxe.ui.HaxeUIApp;
import haxe.ui.Toolkit;
import haxe.ui.components.Button;
import haxe.ui.components.TextArea;
import haxe.ui.components.TextField;
import haxe.ui.core.Component;
import haxe.ui.core.Screen;
import haxe.ui.core.MouseEvent;
import haxe.ui.macros.ComponentMacros;
import lime.media.AudioBuffer;
import openfl.media.Sound;
import openfl.events.Event;

import sys.io.File;

class Main {
	private static var _main:Null<Component>;
	static var app:HaxeUIApp;
	static var _conn:TcpConnection;
	
    public static function main() {
        //Toolkit.scale = 2.5;
        //Toolkit.theme = "native";
		Toolkit.autoScale = true;
        app = new HaxeUIApp();
        app.ready(function() {
            _main = ComponentMacros.buildComponent("assets/ui/init.xml");

            app.addComponent(_main);
            app.start();
        });
		
		cast(_main.findComponent("sound"), Button).onClick = function(e:MouseEvent){			
			var wav:Bytes = File.getBytes("assets/sample.wav");
			var audio:AudioBuffer = AudioBuffer.fromBytes(wav);
			trace(audio.bitsPerSample);
			trace(audio.sampleRate);
			var sound:Sound = Sound.fromAudioBuffer(audio);
			sound.play(0, 0).addEventListener(Event.SOUND_COMPLETE, function(e:Dynamic){
				trace("finished"); 
				sound.play(0, 0);
			});
		};
		
    }
		
	static function receiver(s:String){
//		trace("got " + s);
		cast(_main.findComponent("text"), TextArea).text += s + "\n";
		_conn.recvString(receiver);
	}
	
	private static function switchToConn(){
		if (_main != null)
			app.removeComponent(_main);
		_main = ComponentMacros.buildComponent("assets/ui/conn.xml");
		app.addComponent(_main);
		cast(_main.findComponent("send"), Button).onClick = function(e:MouseEvent){
//			trace("send " +cast(_main.findComponent("message"), TextField).text);
			_conn.sendString(cast(_main.findComponent("message"), TextField).text);
		};
		_conn.recvString(receiver);
	}
}