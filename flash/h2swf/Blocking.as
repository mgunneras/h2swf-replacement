package h2swf {
	
	import flash.display.*;
	import flash.text.*;
	import flash.geom.ColorTransform;
	import fl.motion.Color;
	
	public class Blocking extends MovieClip {
		
		public var _color:Number;
		public var _alpha:Number;
		public var _default_blocking:Array;
		public var _line_height:Number;
		private var _tlines:Array;
		private var _sprite:Sprite;
		private var _baseline_height;
		private var _pad_asc;
		private var _pad_desc;
		
		public function Blocking(color, alpha, default_blocking, pad_asc, pad_desc){
			_color=parseInt("0x"+color);
			_alpha=alpha;
			_default_blocking = default_blocking;
			_pad_asc = pad_asc;
			_pad_desc = pad_desc;
			_sprite = new Sprite();
			_sprite.alpha = alpha;
			addChild(_sprite);
		}
		
		public function clear() {
			_tlines = new Array();
			_sprite.graphics.clear()
			_sprite.graphics.beginFill(_color);
		}

		public function add_tline(line:TLine) {	
			_tlines.push(line);
		}
		
		public function set_line_height(line_height:Number) {

			_line_height = line_height - .5;
			
			// TODO: Calculate this based on actual rendering of the font.
			// currently just using whatever Helvetica Neue does for baseline
			// wich is 79.3 % of total height
			_baseline_height = (_line_height * 0.85);
		}
		
		public function line_height() {
			return _line_height;
		}
		
		public function draw() {
			_sprite.graphics.moveTo(0, 0); // starting position (1)
			
			var cx=0;
			var cy=0;
			var bring_over_y=0;
			
			for(var i=0; i < _tlines.length; i++) {
				var c = _tlines[i];
				var n = _tlines[i+1];
				var p = _tlines[i-1];
				
				/*
					MOVE STEP ONE (2) (right)
				*/
				
				cx = c.width(false) + _default_blocking[3] + _default_blocking[1];
				
				_sprite.graphics.lineTo(cx, cy);					
				
				
				
				/*
					MOVE STEP TWO (3) (down)
				*/
				
				bring_over_y = bring_over_y+line_height();
				cy = bring_over_y;

				// first
				if(i==0) {
					// add height for initial top blocking
					cy += _default_blocking[0];
					bring_over_y += _default_blocking[0];
				}
				
				// last
				if(i==(_tlines.length-1)){
					cy += _default_blocking[2];

					if(c.has_descenders()){
						cy += _pad_desc;
					}
				}
				
				// if next
				if(n){
					// if next is longer
					if(n.width(false) > c.width(false)) {
						// only go to baseline for this one
						cy -= line_height() - c.baseline();
					}
					
					// if next if shorter
					if(n.width(false) < c.width(false)) {
						// only go to baseline for this one
						cy += line_height() - c.baseline();
					}
					
				}

				_sprite.graphics.lineTo(cx, cy);
				
			}			
			
			_sprite.graphics.lineTo(0, cy); // (4)
			
			_sprite.graphics.endFill(); // finish up
			
		}
		
		public function extra_width ():Number {
			return _default_blocking[1] + _default_blocking[3];
		} 
		
		

		/*
		if(has_ascenders(pieces[i]) && i==0 && _pad_asc != 0){
			blocking[0] += _pad_asc;
		}

		if(has_descenders(pieces[i]) && i==pieces.length-1 && _pad_desc != 0){
			blocking[2] += _pad_desc;
		}
		*/
				
		
	}
	
}