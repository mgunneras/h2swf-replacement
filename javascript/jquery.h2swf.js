document.h2swf_id_counter = 0;
document.h2swf_callbacks = [];
(function ($) {
	$.extend($.fn, {
		h2swf: function (options) {

			var defaults = {
				debug : false,
				divider : '|',
				width : null, // add checking if this is not set
				height : null, // add checking if this is not set
				swf : "../flash/header.swf",
				wmode : "transparent",
				color : null,
				background_color : null,
				alpha : .5,
				blocking : [0, 0, 0, 0],
				tracking : 0,
				leading : 0,
				pad_asc : null, // not yet implemented
				pad_desc : 0,
				sharpness : 0, // -400 to 400
				thickness : 0, // -200 to 200
				wraptext : true,
				auto_adjust_window : true,
				on_ready_callback : function(){}
			};

			options = $.extend(defaults, options);
			
			return this.each(function () {
				
				var el = $(this);

				var source = el.hasClass('h2swf') ? el.find('span').html() : el.html();
				
				// read text inside the element.
				var text = source.replace(/\<br\>/g, '<BR>').split('<BR>');
				
				// append the text to span inside the el
				el.html('<span>'+source+'</span>');
				
				el.addClass('h2swf');
				
				// trim whitespace on all pieces
				for(var i = 0; i < text.length; i++)
					text[i] = text[i].replace(/^\s+|\s+$/g, '');
				
				// count the rows
				var rows = text.length;
				
				// swap row breaks with divider
				text = text.join('|');
								
				// attach a id to the element.
				var id = 'h2swf'+document.h2swf_id_counter++;
				
				// append our new flash container inside
				el.append('<div id="'+id+'"></div>');
				var container = $('#'+id);
				
				// make the element a block element.
				container.css('display', 'block');
				
				// calculate height and set it to the element.
				if(options.width != 'callback' && options.width != null){
					container.css('width', options.width || el.css('width'));
					max_width = parseInt(options.width);
				}else{
					max_width = 0;
				}
				if(options.height != 'callback' && options.width != null){
					container.css('height', options.height || el.css('height'));
				};

				// create swf object and set it's flashvars and params.
				var params = {
					wmode: options.wmode
				};
				
				var attributes = {
					id: id
				};
				
				document.h2swf_callbacks[id] = { 
					callback : options.on_ready_callback,
					options: options
				};
				
				var flashvars = {
					id : id,
					debug : options.debug ? 1 : 0,
					render_txt : text,
					color : options.color ? options.color :  CSSColorToHex(el.css('color')),
					background_color : options.background_color ? options.background_color :  CSSColorToHex(el.css('background-color')),
					alpha : options.alpha,
					line_height : options.line_height,
					font_size : options.font_size,
					tracking : options.tracking,
					leading : options.leading,
					blocking : options.blocking.join('|'),
					pad_asc : options.pad_asc,
					pad_desc : options.pad_desc,
					sharpness : options.sharpness,
					thickness : options.thickness,
					callback : "h2swf_callback",
					max_width : max_width,
					auto_adjust_window : options.auto_adjust_window,
					max_width : options.width
				};
				
				el.find('span').hide(); // hide real text. We might want to do this in a more accessible way here.
				el.find('object').remove(); // remove old h2swf's TODO: check for last id here instead of all object tags?
				el.css('background', 'none');
				swfobject.embedSWF(options.swf, id, container.css('width'), container.css('height'), "9.0.0", "expressInstall.swf", flashvars, params, attributes);
			});
			
			// utility functions
			function CSSColorToHex(css_str) { var a = css_str.replace(new RegExp(/[^0-9+,]/g), '').split(','); return RGBtoHex(a[0], a[1], a[2]) }
			function RGBtoHex(R,G,B) {return toHex(R)+toHex(G)+toHex(B)}
			function toHex(N) { if (N==null) return "00"; N=parseInt(N); if (N==0 || isNaN(N)) return "00"; N=Math.max(0,N); N=Math.min(N,255); N=Math.round(N); return "0123456789ABCDEF".charAt((N-N%16)/16) + "0123456789ABCDEF".charAt(N%16); }
		}
	});
})(jQuery);
function h2swf_callback(id, width, height) {
	var settings = document.h2swf_callbacks[id];
	settings.callback(id, width, height);	
	if(settings.options.width == 'callback'){
		$('#'+id).css('width', width);
	}
	if(settings.options.height == 'callback'){
		$('#'+id).css('height', height);
	}
}