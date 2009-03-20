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
		private var _max_width:Number;
		private var _widow_fix:Boolean;
		private var string_helper:StringHelper;
	
		public function StripManager(target_mc:MovieClip, id, font_size, color, bg_color, alpha, blocking, leading, tracking, pad_asc, pad_desc, sharpness, thickness, max_width, widow_fix) {
			
			_target_mc = target_mc;
			_strip_containers = new Array();
			
			_id = id;
			_font_size = font_size;
			_color = color;
			_leading = leading;
			_tracking = tracking;
			_sharpness = sharpness;
			_thickness = thickness;
			_max_width = max_width;
			_widow_fix = widow_fix;
			
			string_helper = new StringHelper(); 
			
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
			
			_blocking.clear();
						
			pieces = auto_adjust_for_width(pieces);
			if(_widow_fix){
				pieces = auto_adjust_for_widows(pieces);
			}
			
			for(var i=0; i< pieces.length; i++) {
				_blocking.add_tline(get_tline(pieces[i]));
			}
			
			var text_strip = get_text_strip();
			text_strip.set_text(pieces.join('\n'));
			
			text_strip.x = _blocking._default_blocking[3];
			text_strip.y = _blocking._default_blocking[0];
			
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
		
		
		public function get_tline(str) {
			var tline = new TLine(str);
			tline.set_text_strip(get_text_strip());
			return tline;
		}
		
		/*
			if a line ends up beeing longer than max_width
			we move some text over to the next line.
		*/
		public function auto_adjust_for_width(pieces):Array {
			var final_pieces = new Array();
			while(pieces.length) {
				var piece = pieces.shift();
				if(!piece){ trace('Empty piece, moving on.'); continue; } // if empty line
				//return final_pieces;
				if(get_tline(piece).width()+_blocking._default_blocking[1]+_blocking._default_blocking[3] > _max_width){
					// too wide so let's cut the piece down by one word
					if(piece.split(" ").length <= 1){
						trace('Only one word so nothing to do but move on.');
					}else{
						var word_array = piece.split(" ");
						var last_word:String = word_array.pop();
						// add the last word to next line.
						if(!pieces[0]) { pieces[0] = ""; }
						pieces[0] = string_helper.trim(pieces[0] + " " + last_word, ' ');
						// now let's put this piece back together again.
						piece = word_array.join(" ");
						// we then add this piece back to the front of the array
						// making this loop sort of recursive.
						pieces.unshift(piece);
						continue;
					}
				}
				// add to final
				final_pieces.push(piece);
			}
			return final_pieces;
		}
		
		/*
			if we have a single word (a widow) on the last line,
			and the previous line has 3 or more words, we move the last word down 
			so we always end the last line with 2 words.
		*/
		public function auto_adjust_for_widows(pieces):Array {
			if(pieces.length > 1 && pieces[pieces.length-1].split(' ').length == 1 && pieces[pieces.length-2].split(' ').length >= 3){
				var prev_arr:Array = pieces[pieces.length-2].split(' ');
				pieces[pieces.length-1] = prev_arr.pop() + ' ' + pieces[pieces.length-1];
				pieces[pieces.length-2] = prev_arr.join(' ');
			}
			return pieces
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