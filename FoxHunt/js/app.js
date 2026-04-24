/*
 *  Document   : app.js
 *  Author     : pixelcave
 *  Description: Custom scripts and plugin initializations
 */

var App = function () {
	
    var isMobile = false;
    /* Initialization UI Code */
    var uiInit = function () {

	// device detection
	if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) 
    || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0, 4)))
	    isMobile = true;
	
        // Handle UI 
        handleHeader();
        handleMenu();
        scrollToTop();
        translate();
        // Add the correct copyright year at the footer
        //var yearCopy = $('#year-copy'), d = new Date();
        //if (d.getFullYear() === 2014) { yearCopy.html('2014'); } else { yearCopy.html('2014-' + d.getFullYear().toString().substr(2,2)); }

        // Intialize ripple effect on buttons
        //rippleEffect($('.btn-effect-ripple'), 'btn-ripple');

        // Initialize tabs
        //$('[data-toggle="tabs"] a, .enable-tabs a').click(function(e){ e.preventDefault(); $(this).tab('show'); });

        // Initialize Tooltips
        //$('[data-toggle="tooltip"], .enable-tooltip').tooltip({container: 'body', animation: false});

        // Initialize Popovers
        //$('[data-toggle="popover"], .enable-popover').popover({container: 'body', animation: true});

        // Initialize Placeholder (for IE9)
        //$('input, textarea').placeholder();

        // Initialize Image Lightbox
        //$('[data-toggle="lightbox-image"]').magnificPopup({type: 'image', image: {titleSrc: 'title'}});

        // Initialize image gallery lightbox
        /*$('[data-toggle="lightbox-gallery"]').each(function(){
            $(this).magnificPopup({
                delegate: 'a.gallery-link',
                type: 'image',
                gallery: {
                    enabled: true,
                    navigateByImgClick: true,
                    arrowMarkup: '<button type="button" class="mfp-arrow mfp-arrow-%dir%" title="%title%"></button>',
                    tPrev: 'Previous',
                    tNext: 'Next',
                    tCounter: '<span class="mfp-counter">%curr% of %total%</span>'
                },
                image: {titleSrc: 'title'}
            });
        });
		*/
        // Toggle animation class when an element appears with Jquery Appear plugin
        /*$('[data-toggle="animation-appear"]').each(function(){
            var $this       = $(this);
            var $animClass  = $this.data('animation-class');
            var $elemOff    = $this.data('element-offset');

            $this.appear(function() {
                $this.removeClass('visibility-none').addClass($animClass);
            },{accY: $elemOff});
        });
		*/
        // With CountTo (+ help of Jquery Appear plugin), check out examples and documentation at https://github.com/mhuggins/jquery-countTo
        /*$('[data-toggle="countTo"]').each(function(){
            var $this = $(this);

            $this.appear(function() {
                $this.countTo({
                    speed: 2000,
                    refreshInterval: 20,
                    onComplete: function() {
                        if($this.data('after')) {
                            $this.html($this.html() + $this.data('after'));
                        }
                    }
                });
            });
        });
		*/
        // With vPageScroll, check out examples and documentation at https://github.com/nico-martin/vPageScroll (init in IE10 and up)
        if (!$('html').hasClass('lt-ie10')) {
            $('.scroller-container').vpagescroll({
                sectionContainer: '.scroller-container > section',
                sectionInner: '.scroller-container > section > .container',
                navigation: '.scroller-nav'
            });
        }


    };

    /* Ripple effect on click functionality */
    var rippleEffect = function (element, cl) {
        // Add required classes to the element
        element.css({
            'overflow': 'hidden',
            'position': 'relative'
        });

        // On element click
        element.on('click', function (e) {
            var elem = $(this), ripple, d, x, y;

            // If the ripple element doesn't exist in this element, add it..
            if (elem.children('.' + cl).length == 0) {
                elem.prepend('<span class="' + cl + '"></span>');
            }
            else { // ..else remove .animate class from ripple element
                elem.children('.' + cl).removeClass('animate');
            }

            // Get the ripple element
            var ripple = elem.children('.' + cl);

            // If the ripple element doesn't have dimensions set them accordingly
            if (!ripple.height() && !ripple.width()) {
                d = Math.max(elem.outerWidth(), elem.outerHeight());
                ripple.css({ height: d, width: d });
            }

            // Get coordinates for our ripple element
            x = e.pageX - elem.offset().left - ripple.width() / 2;
            y = e.pageY - elem.offset().top - ripple.height() / 2;

            // Position the ripple element and add the class .animate to it
            ripple.css({ top: y + 'px', left: x + 'px' }).addClass('animate');
        });
    };
    var header = $('header');
    var headerImage = $(".headerImg");
    /* Handles Header */
    var handleHeader = function () {
		if(isMobile){
			header.addClass('notransition');
			headerImage.addClass('notransition');
		}
        $(window).scroll(function () {
            // If the user scrolled a bit (150 pixels) alter the header class to change it
            if ($(this).scrollTop() > 10) {
                compressheader();
            } else {
                header.removeClass('header-scroll');
				//headerImage.animate({height: "100px",paddingleft: "20px"},120)
				headerImage.removeClass('headerImg-scroll')
            }
        });
    };

    var compressheader = function () {
        header.addClass('header-scroll');
        //headerImage.animate({height: "50px",paddingleft: "0px"},120)
        headerImage.addClass('headerImg-scroll')
    };

    /* Handles Main Menu */
    var handleMenu = function () {
        var sideNav = $('.sitenav');

        $('.site-menu-toggle').on('click', function () {
            sideNav.toggleClass('sitenav-visible');
        });

        sideNav.on('mouseleave', function () {
            $(this).removeClass('sitenav-visible');
        });
    };

    /* Scroll to top functionality */
    var scrollToTop = function () {
        // Get link
        var link = $('#to-top');
        var windowW = window.innerWidth
                        || document.documentElement.clientWidth
                        || document.body.clientWidth;

        $(window).scroll(function () {
            // If the user scrolled a bit (150 pixels) show the link in large resolutions
            if (($(this).scrollTop() > 150) && (windowW > 991)) {
                link.fadeIn(100);
            } else {
                link.fadeOut(100);
            }
        });

        // On click get to top
        link.click(function () {
            $('html, body').animate({ scrollTop: 0 }, 400);
            return false;
        });
    };

    var translate = function (selector) {
        if ($(".cke_editable").length > 0)
            return;
        //translate text
        var dict = {
              "Home": {esp: "Casa"}
            //, "Confirmation": { esp: "Confirmaci&oacute;n" },
            , "Confirmation": { esp: "Confirmación" }
            , "Menu": { esp: "Menú" }
            , "Close": {esp: "Cerrar"}
            , "Accept": {esp: "Aceptar"}
            , "Help": { esp: "Ayuda" }
            , "By checking this box you agree to the above terms and conditions.": { esp: "Al marcar esta casilla, usted está de acuerdo con los términos y condiciones citados arriba." }
            , "Submit Form": { esp: "Enviar el formulario" }
            , "Your": { esp: "Tu" }
            , "Program": { esp: "Programa" }
            , "month": { esp: "mes" }
            , "day": { esp: "día" }
            , "year": { esp: "año" }
            , "Find me": { esp: "Buscar" }
            , "Upload Files Here": { esp: "Subir archivos aquí" }
            , "Comment": { esp: "Comentario" }
            , "Complaint": { esp: "Queja" }
            , "Browse for image": { esp: "Buscar imagen" }
            , "Send": { esp: "Enviar" }
            , "Submit": { esp: "Enviar" }
            , "Subject": { esp: "Tema" }
            , "Question": { esp: "Pregunta" }
            , "Jan": { esp: "Ene" }
            , "Apr": { esp: "Abr" }
            , "Your": { esp: "Su" }
            , "APPLICATIONS": { esp: "APLICACIONES (Servicios de Nutricion)" }
            , "REDETERMINATIONS": { esp: "REDETERMINACIONES (Servicios de Nutricion)" }
            , "CHANGES": { esp: "CAMBIOS (Servicios de Nutricion)" }
        }

        var translate = function (lang, selector) {
            for (var k in dict) {
                if (dict[k][lang]) {
                    replaceText(selector, k, dict[k][lang], 'g');
                    //console.log("replaceText('" + selector + "', " + k + ", " + dict[k][lang] + ", 'g');")
                }
            }
        }
        if (!selector)
            selector = "*";

        translate(lang, selector);
        //var translator = $('body').translate({ lang: "en", t: dict }); //use English
        //translator.lang("esp"); //change to Portuguese
    }

    return {
        init: function () {uiInit(); },
        compressheader: function () { compressheader();}
		, isMobile: isMobile
        , translate: function (selector) { translate(selector); }
    };
}();

/* Initialize app when page loads */
$(function () { App.init(); });



function replaceText(selector, text, newText, flags) {
    var matcher = new RegExp(text, flags);
    $(selector).each(function () {
        var $this = $(this);
        
        //$this[0].innerHTML = $this[0].innerHTML.replace(matcher, HtmlEncode(newText));
        if (!$this.children().length)
            $this.html($this.text().replace(matcher, newText));
        if ($this.prop("tagName") !="OPTION" && matcher.test($this.val()))
            $this.val($this.val().replace(matcher, newText));
    });
}
function HtmlEncode1(s)
{
   
    return encodeURIComponent(s);
}

function HtmlEncode(str) {
    var i = str.length,
        aRet = [];

    while (i--) {
        var iC = str[i].charCodeAt();
        if (iC < 65 || iC > 127 || (iC > 90 && iC < 97)) {
            aRet[i] = '&#' + iC + ';';
        } else {
            aRet[i] = str[i];
        }
    }
    return aRet.join('');
}

$.fn.isOnScreen = function () {

    var win = $(window);

    var viewport = {
        top: win.scrollTop(),
        left: win.scrollLeft()
    };
    viewport.right = viewport.left + win.width();
    viewport.bottom = viewport.top + win.height();

    var bounds = this.offset();
    bounds.right = bounds.left + this.outerWidth();
    bounds.bottom = bounds.top + this.outerHeight();

    return (!(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom));

};

/* ===========================================================
 * jquery-vPageScroll.js v1.0
 * ===========================================================
 * Copyright 2014 Nico Martin.
 * http://www.vir2al.ch
 *
 * License: GPL v3
 *
 * ========================================================== */
function vp_GoTo(t, i) { var n = $(document).width(); if (719 > n) var a = 50; else var a = 0; scroll = i - a, $("html, body").animate({ scrollTop: scroll }, "slow") } !function (t, i, n) { function a(a) { var o = i.innerHeight; if (t(n).width() < 719) var s = 50; else var s = 0; t(a.sectionContainer).each(function () { var i = { position: "relative", "min-height": o - s + "px", "-webkit-transition": "all 0.2s", "-moz-transition": "all 0.2s", "-o-transition": "all 0.2s" }; t(this).css(i), t(this).find(a.sectionInner).each(function () { var i = t(".container-12").width(); if (t(this).height() + 50 < o) { var n = t(this).height() / 2, a = { position: "absolute", top: "50%", "margin-top": "-" + (Math.round(n) + 50) + "px", width: i + "px" }; t(this).css(a) } else { var a = { position: "relative", top: "0", "margin-top": "0px", width: i + "px" }; t(this).css(a) } }) }) } function o(i) { t(i.sectionContainer).each(function () { if (void 0 != t(this).attr("data-color")) { var i = t(this).attr("data-color"); t(this).css("background-color", i) } }) } function s(i) { var n = "<ul>", a = 1; t(i.sectionContainer).each(function () { if (t(this).attr("id", a), void 0 != t(this).attr("data-icon")) var i = t(this).attr("data-icon"); else var i = "fa-chevron-right"; if (void 0 != t(this).attr("data-title")) var o = "<span>" + t(this).attr("data-title") + "</span>"; else var o = ""; var s = t(this).offset().top; n = n + "<li>" + o + '<a data-id="' + a + '" onclick="vp_GoTo(\'' + a + "'," + s + ')"><i class="fa ' + i + '"></i></a></li>', a++ }), n += "</ul>", t(i.navigation).html(n), t(i.navigation).addClass("vpagescroll_navigation"); var o = t(i.navigation).height() / 2; t(i.navigation).css("margin-top", "-" + o + "px"), t(".vpagescroll_navigation ul li").hover(function () { t(this).find("span").fadeIn(200) }, function () { t(this).find("span").fadeOut(200) }) } function e(n) { t(n.sectionContainer).each(function () { var n = i.pageYOffset, a = n - t(this).offset().top, o = t(this).attr("id"), s = t(this).height(); s - 60 > a && a > -60 && (history.pushState ? history.pushState(null, null, "#" + o) : location.hash = "#" + o, t(".vpagescroll_navigation ul li a").each(function () { t(this).attr("data-id") == o ? t(this).addClass("active") : t(this).removeClass("active") })) }) } t.fn.vpagescroll = function (r) { var c = t.extend({ sectionContainer: "section", sectionInner: ".inner", navigation: "#navigation" }, r); t(c.sectionInner).each(function () { t(this).append('<div style="clear:both"></div>') }), t(this).append('<div id="navi_shadow"></div>'), o(c), setTimeout(function () { a(c) }, 200), setTimeout(function () { s(c) }, 500), t(i).resize(function () { setTimeout(function () { a(c) }, 500), setTimeout(function () { s(c) }, 1e3) }), t(n).scroll(function () { e(c) }) } }(jQuery, window, document);