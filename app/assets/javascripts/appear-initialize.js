is_touch_screen = 'ontouchstart' in document.documentElement;
width = window.innerWidth;

if(is_touch_screen || width < 640) {
    console.log("it works")
} else {
	$(function() {
	  var $appeared = $('.about-us .text, .about-us .text-middle, .our-kitchen .text, .dish-frame, .inner-text-right, .line-left, .chef-photo, .price-right, .price-left, .left-to-right, .right-to-left');
	  $appeared.appear();
	  $(document.body).on('appear', function(e, $affected) {
	    $affected.addClass('appeared')
	  });
	});
}