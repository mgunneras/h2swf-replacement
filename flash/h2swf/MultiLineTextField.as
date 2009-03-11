package h2swf {
	
	import flash.display.*;
	import flash.text.*;
	import flash.geom.ColorTransform;
	
	public class MultiLineTextField extends MovieClip {
	
		public 		var textfield:TextField;
		public		var _textformat:TextFormat;
	
		public 		var _txt:String;
		public 		var _font_size:Number;
		public		var _blocking:Array;
		public		var _leading:Number;
		public		var _tracking:Number;
		public		var _sharpness:Number;
		public		var _thickness:Number;
	
		public function MultiLineTextField() {
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.selectable = true;
			textfield.antiAliasType = AntiAliasType.ADVANCED;
			textfield.gridFitType = GridFitType.PIXEL;
			_textformat = new TextFormat();
		}
	
		public function set_text(txt) {
			_txt = txt;
			re_draw();
		}
	
/*		public function set_bg_color(bg_color:String) {
			var newColorTransform:ColorTransform = bg.transform.colorTransform;
			newColorTransform.color = parseInt("0x"+bg_color);
			bg.transform.colorTransform = newColorTransform;
		}
*/	
		public function set_color(c:String) {
			textfield.textColor=parseInt("0x"+c);
		}
	
/*		public function set_alpha(a:Number) {
			bg.alpha = a;
		}
*/	
/*		public function set_blocking(blocking:Array) {
			_blocking = blocking;
		}
*/	
		public function set_leading(leading:Number) {
			_leading = leading;
		}

		public function set_tracking(tracking:Number) {
			_tracking = tracking;
		}

		public function set_font_size(font_size:Number) {
			_font_size = font_size;
		}
		
		public function set_sharpness(sharpness) {
			_sharpness = sharpness;
		}

		public function set_thickness(thickness) {
			_thickness = thickness;
		}

		public function re_draw() {
			// set the new padding
/*			textfield.x = _blocking[3];
			textfield.y = _blocking[0];
*/
			// format the text
			textfield.sharpness = _sharpness;  // -400 to 400
			textfield.thickness	= _thickness; // -200 to 200 
			
			_textformat.leading = _leading;
			_textformat.letterSpacing = _tracking;
			_textformat.size = _font_size;
			_textformat.kerning = true;
			textfield.defaultTextFormat = _textformat;

			// set the text
			textfield.text = _txt;

			// strech the background
/*			bg.width = textfield.width + (parseInt(_blocking[3])+parseInt(_blocking[1]));
			bg.height = textfield.height + (parseInt(_blocking[0])+parseInt(_blocking[2]));
*/		}
			
	}
}