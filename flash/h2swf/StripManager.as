package h2swf {
	
	import flash.display.*;
	import flash.text.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.external.ExternalInterface;
	
	public class StripManager extends Object {
	
		public var _target_mc:MovieClip;
		private var _strip_containers:Array;
		public var _blocking:Blocking;

		private var _id:String;
		private var _font_size:Number;
		private var _color:String;
		private var _leading:Number;
		private var _tracking:Number;
		private var _sharpness:Number;
		private var _thickness:Number;		
	
		public function StripManager(target_mc:MovieClip, id, font_size, color, bg_color, alpha, blocking, leading, tracking, pad_asc, pad_desc, sharpness, thickness) {
			
			_target_mc = target_mc;
			_strip_containers = new Array();
			
			_id = id;
			_font_size = font_size;
			_color = color;
			_leading = leading;
			_tracking = tracking;
			_sharpness = sharpness;
			_thickness = thickness;
			
			_blocking = new Blocking(bg_color, alpha, blocking, pad_asc, pad_desc);
			_target_mc.addChild(_blocking);
			
			_target_mc.alpha = 1;

			// add external access to the show and hide methods
			ExternalInterface.addCallback("show", this.show);
			ExternalInterface.addCallback("hide", this.hide);
			ExternalInterface.addCallback("build_header", this.build_header);
		}
		
		public function show() {
			_target_mc.alpha = 1;
		}
		
		public function hide() {
			_target_mc.alpha = 0;
		}
			
		/*
			Takes an array of strings as argument
			and draws a MultiLineTextField
		*/
		public function build_header(pieces:Array, quick_reset:Boolean):Array {
			
			while(_strip_containers.length) {
				_target_mc.removeChild(_strip_containers.pop())
			}
			
			var text_strip = get_text_strip();
			text_strip.set_text(pieces.join('\n'));
			
			_blocking.clear();

			text_strip.x = _blocking._default_blocking[3];
			text_strip.y = _blocking._default_blocking[0];
			
			for(var i = 0; i < pieces.length; i++) {

				if(!pieces[i]){ continue; }

				var tline = new TLine(pieces[i]);
				tline.set_text_strip(get_text_strip());
				_blocking.add_tline(tline);
				
			}
			
			_blocking.set_line_height(text_strip.height/pieces.length);
			_blocking.draw();
			
			// save container
			_strip_containers.push(text_strip);
			
			// add it to the target
			_target_mc.addChild(text_strip);
			
			//new Tween(container, 'alpha', Regular.easeIn, 0, 1, .4, true);
			//Application.log('Finished Building Header: ' + pieces);
			return new Array(_blocking.width, _blocking.height);
		}
			
		// simple MultiLineTextField factory
		public function get_text_strip():MultiLineTextField {
			var text_strip = new MultiLineTextField;
			// set the global properties
			text_strip.set_color(_color);
			text_strip.set_font_size(_font_size);
			text_strip.set_leading(_leading);
			text_strip.set_tracking(_tracking);
			text_strip.set_sharpness(_sharpness);
			text_strip.set_thickness(_thickness);
			return text_strip;
		}
		
	
	}
}