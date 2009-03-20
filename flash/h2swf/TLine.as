package h2swf { 
	
	import 	flash.text.TextLineMetrics;
	
	class TLine {
		
		public var text_strip:MultiLineTextField;
		
		public var the_string:String;
		public var metrics:TextLineMetrics;
		
		public function TLine(string:String) {
			the_string = string;
		}

		public function has_ascenders():Boolean {
			var r:RegExp = /[A-Z0-9bdfhijklt]/g;
		    return r.test(the_string);
		}

		public function has_descenders():Boolean {
			var r:RegExp = /[gjpqy]/g;
		    return r.test(the_string);
		}
		
		public function set_text_strip(ts:MultiLineTextField) {
			text_strip = ts;
			text_strip.set_text(the_string);
			metrics = text_strip.textfield.getLineMetrics(0);
		}
		
		public function set_text(t:String) {
			the_string = t;
			if(text_strip)
				text_strip.set_text(the_string);
		}
		
		public function width(blocking) {
			if (blocking) {
				return text_strip.width+blocking._default_blocking[1]+blocking._default_blocking[3];
			}else{
				return text_strip.width;
			}			
		}
		
		public function baseline() {
			return metrics.ascent;
		}

/*		public function height() {
			var txt = text_strip._txt;
			text_strip.set_text("two\nlines");
			var h = text_strip.height / 2;
			text_strip.set_text(txt);
			return h;
		}
*/						
	}
}