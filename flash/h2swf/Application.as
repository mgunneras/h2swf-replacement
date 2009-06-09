package h2swf {
	
	import flash.display.*;
	import flash.text.*;
	import flash.utils.ByteArray;
	import flash.external.*;
	import flash.system.Capabilities;
	import flash.utils.*;
	import flash.events.Event;
	
	public class Application extends MovieClip {
	
		private static var _debug;
		private var _id;
		private var _render_txt;
		private var _background_color;
		private var _color; 			
		private var _alpha;
		private var _blocking;		
		private var _leading;			
		private var _tracking;		
		private var _font_size;		
		private var _pad_asc;
		private var _pad_desc;
		private var _sharpness;
		private var _thickness;
		public var _manager:h2swf.StripManager;
		private var _start_hidden;
		private var _callback;
		private var _max_width;
		private var _wordwrap;
		private var _prevent_widow;
		private var _width_threshold;		
		
		
		public function Application() {
						
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			try{
				_render_txt = StringHelper.htmlUnescape(getSwfVar( 'render_txt' ));
			} catch (e:Error) {
				_render_txt = "";
			}
			
			try{
				_background_color = getSwfVar( 'background_color' );
			} catch (e:Error) {
				_background_color = "00FF00";
			}

			try{
				_color = getSwfVar( 'color' );
			} catch (e:Error) {
				_color = "FF0000";
			}

			try{
				_alpha = parseFloat(getSwfVar( 'alpha' ));
			} catch (e:Error) {
				_alpha = .3;
			}

			try{
				_blocking = getSwfVar( 'blocking' );
				_blocking = _blocking.split('|');
				for(var i = 0; i < _blocking.length; i++){
					_blocking[i] = parseInt(_blocking[i]);
				}
			} catch (e:Error) {
				_blocking = [10, 15, 4, 10];
			}

			try{
				_leading = parseInt(getSwfVar( 'leading' ));
			} catch (e:Error) {
				_leading = -5;
			}

			try{
				_tracking = parseInt(getSwfVar( 'tracking' ));
			} catch (e:Error) {
				_tracking = -4;
			}

			try{
				_font_size = parseInt(getSwfVar( 'font_size' ));
			} catch (e:Error) {
				_font_size = 72;
			}

			try{
				_pad_asc = parseInt(getSwfVar( 'pad_asc' ));
			} catch (e:Error) {
				_pad_asc = 0;
			}

			try{
				_pad_desc = parseInt(getSwfVar( 'pad_desc' ));
			} catch (e:Error) {
				_pad_desc = 6;
			}

			try{
				Application._debug = parseInt(getSwfVar( 'debug' ));
			} catch (e:Error) {
				Application._debug = false;
			}

			try{
				_sharpness = parseInt(getSwfVar( 'sharpness' ));
			} catch (e:Error) {
				_sharpness = 0;
			}

			try{
				_thickness = parseInt(getSwfVar( 'thickness' ));
			} catch (e:Error) {
				_thickness = 0;
			}

			try{
				_id = getSwfVar( 'id' );
			} catch (e:Error) {
				_id = "empty";
			}

			try{
				_callback = getSwfVar( 'callback' );
			} catch (e:Error) {
				_callback = "";
			}

			try{
				_max_width = getSwfVar( 'max_width' );
			} catch (e:Error) {
				_max_width = 500;
			}

			try{
				_wordwrap = parseInt(getSwfVar( 'wordwrap' ));
			} catch (e:Error) {
				_wordwrap = true;
			}

			try{
				_prevent_widow = parseInt(getSwfVar( 'prevent_widow' ));
			} catch (e:Error) {
				_prevent_widow = 0;
			}

			try{
				_width_threshold = parseInt(getSwfVar( 'width_threshold' ));
			} catch (e:Error) {
				_width_threshold = 5;
			}
						
			loaderInfo.addEventListener(Event.INIT, initHandler);			
		}
		
		public function initHandler(e:Event) {

			_manager = new h2swf.StripManager(this, _id, _font_size, _color, _background_color, _alpha, _blocking, _leading, _tracking, _pad_asc, _pad_desc, _sharpness, _thickness, _max_width, _wordwrap, _prevent_widow, _width_threshold);
			
			var sizes:Array = new Array(0, 0);
			if(_render_txt)
				sizes =	_manager.build_header(_render_txt.split('|'), true);
			
			flash.external.ExternalInterface.call(_callback, _id, sizes[0], sizes[1]);
			
			// run tests here.
			if(Capabilities.playerType == 'External'){
				run_timed_tests();
			}
		}
		
		public function getSwfVar( key:String ) {
			if(!loaderInfo)	{String
				throw new Error( "getSwfVar() fails. LoaderInfo not found in " + this );
			}
			if(loaderInfo.parameters[key] == undefined) {
				throw new Error( "getSwfVar() fails. Parameter " + key + " not found in loaderInfo parameters of " + this );
			}
			return loaderInfo.parameters[key];
		}
		
		
		public static function clone(reference:*): Object {
            var clone:ByteArray = new ByteArray();
            clone.writeObject( reference );
            clone.position = 0;
            return clone.readObject();
        }

		public static function log(str:*) {
			trace(str)
			if(_debug){
				flash.external.ExternalInterface.call("console.log", "F: " + str.toString());
			}
		}		
		
		
		/*
			VISUAL TESTS THAT SHOULD ONLY RUN IN 
			THE FLASH AUTHORING TOOL
		*/
		public function run_timed_tests() {
/*			setTimeout(display_test_text, 2000, ['City back in Europe.']);*/
/*			setTimeout(display_test_text, 2000, ['City back', 'in Europe.']);*/
			setTimeout(display_test_text, 3000, ['Three', 'Line', 'Text']);
/*			setTimeout(display_test_text, 4000, ['Some decenders on the last line yes?']);*/
/*			setTimeout(display_test_text, 5000, ['This is a little text with many many small words']);*/
		}		
		public function display_test_text(thetext) {
			_manager.build_header(thetext, false);
		}
		
	}
}
