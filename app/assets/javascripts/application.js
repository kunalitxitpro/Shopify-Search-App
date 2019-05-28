// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require jquery
//= require added-jquery-ui
//= require foundation
//= require turbolinks

$(document).on('turbolinks:load', () => {
    $(function(){ $(document).foundation(); });
    var PageNumber = 1;
    var running = false;
    var canLoadMore = true;
    var modalrunning = false
    var modalShowing = false;

    if ($('.gif-container').length > 0 ) {
      $(window).bind('scroll', function() {
          if($(window).scrollTop() >= $('.product-container').offset().top + $('.product-container').outerHeight() - window.innerHeight) {
            if(running == false){
              running = true;
              $('.js-product-group:hidden').slice(0, 12).fadeIn('slow');
              if ($('.js-product-group:hidden').length <= 1 && canLoadMore){
                $('.loading-gif').fadeIn();
                $.ajax({
                  type: "GET",
                  url: "/apps/index?&filter=true&page=" + PageNumber + Window.paramUrl,
                  data: $(this).serialize(),
                  success: function(response) {
                    if(response.productCount != Window.noOfProducts){
                      canLoadMore = false;
                    }
                    $('.loading-gif').fadeOut();
                    var productID = response.lastProductID;
                    if($('.js-product-id-'+ productID).length == 0){
                      $('.js-all-products').append(response.productsPartial);
                      window.tabs.loadTabs();
                    }
                  }
                });
                PageNumber = PageNumber + 1
              }
              setTimeout(function(){running = false}, 1000);
            }
          }
      });
    } else {
        $(window).scroll(function() {
            clearTimeout($.data(this, 'scrollTimer'));
            $.data(this, 'scrollTimer', setTimeout(function() {
                var scrolled = $(window).scrollTop();
                if (modalrunning == false && !window.matchMedia("(max-width: 800px)").matches && modalShowing == true){
                  $(".the-modal").animate({
                      top: scrolled + 'px',
                    }, 300, function() {
                      modalrunning = false
                  });
                }
                modalrunning = true
            }, 250));
        });
      }

    $('.js-load-more').click(function(){
      var element = this
      $(element).fadeOut()
      $.ajax({
        type: "GET",
        url: "/apps/index?&filter=true&page=" + PageNumber + Window.paramUrl,
        data: $(this).serialize(),
        success: function(response) {
          var productID = response.lastProductID;
          $('.js-all-products').append(response.productsPartial);
          window.tabs.loadTabs();
          $(element).fadeIn()
        }
      });
      PageNumber = PageNumber + 1
    });

    $( "#slider-range" ).slider({
      range: true,
      min: 0,
      max: 500,
      values: [ 75, 300 ],
      slide: function( event, ui ) {
        $( "#amount" ).val( "£" + ui.values[ 0 ] + " - £" + ui.values[ 1 ] );
      }
    });
    $( "#amount" ).val( "£" + $( "#slider-range" ).slider( "values", 0 ) +
      " - £" + $( "#slider-range" ).slider( "values", 1 ) );

    $( "#slider-range-two" ).slider({
      range: true,
      min: 0,
      max: 500,
      values: [ 75, 300 ],
      slide: function( event, ui ) {
        $( "#amount-two" ).val( "£" + ui.values[ 0 ] + " - £" + ui.values[ 1 ] );
      }
    });

    $( "#amount-two" ).val( "£" + $( "#slider-range-two" ).slider( "values", 0 ) + " - £" + $( "#slider-range-two" ).slider( "values", 1 ) );


    $('.js-filter-price').click(function(){
      var min = $( "#slider-range-two" ).slider( "values", 0 )
      var max = $( "#slider-range-two" ).slider( "values", 1 )

      Turbolinks.visit("https://true-vintage-2.myshopify.com/apps/index?price=" + min + "-" + max)
    });

    // $('.file').change(function() {
    //   alert( "Handler for .change() called." );
    //   $('.image-placeholder').css({ 'width': `250px` });
    // });

    $(function() {
      function readURL(input) {
        if (input.files && input.files[0]) {
          const reader = new FileReader();

          reader.onload = function (e) {
            // $('#img_prev').attr('src', e.target.result);
            // $('#img_prev').attr('data-url', e.target.result);
            const newUrl = e.target.result;
            $('#img_prev').css({ 'background-image': `url(${newUrl})` });
          }
          reader.readAsDataURL(input.files[0]);
        }
      }

      $('.file').change(function () {
        $('#img_prev').removeClass('hidden');
        readURL(this);
      });
    });

    $( function() {
      $( "#slider-range" ).slider({
        range: true,
        min: 0,
        max: 500,
        values: [ 75, 300 ],
        slide: function( event, ui ) {
          $( "#amount" ).val( "£" + ui.values[ 0 ] + " - £" + ui.values[ 1 ] );
        }
      });
      $( "#amount" ).val( "£" + $( "#slider-range" ).slider( "values", 0 ) +
        " - £" + $( "#slider-range" ).slider( "values", 1 ) );

        $( "#slider-range-two" ).slider({
          range: true,
          min: 0,
          max: 500,
          values: [ 75, 300 ],
          slide: function( event, ui ) {
            $( "#amount-two" ).val( "£" + ui.values[ 0 ] + " - £" + ui.values[ 1 ] );
          }
        });
        $( "#amount-two" ).val( "£" + $( "#slider-range-two" ).slider( "values", 0 ) +
          " - £" + $( "#slider-range-two" ).slider( "values", 1 ) );

    } );

    $('.js-true-scroll-option').click(function(){
      $('.js-admin-section-filter-config-container, .js-admin-section-search-config-container').hide()
      $('.js-admin-section-scroll-config-container').show()
      $('.js-true-scroll-option').css({'border-left':'5px solid rgb(92, 106, 196)', 'background-color': 'white', 'color': 'rgb(92, 106, 196)'});
      $('.js-true-filter-option, .js-true-search-option').css({'border-left':'0', 'background-color': 'transparent', 'color': 'black'})
    });
    $('.js-true-filter-option').click(function(){
      $('.js-admin-section-scroll-config-container, .js-admin-section-search-config-container').hide()
      $('.js-admin-section-filter-config-container').show();
      $('.js-true-filter-option').css({'border-left':'5px solid rgb(92, 106, 196)', 'background-color': 'white', 'color': 'rgb(92, 106, 196);'});
      $('.js-true-scroll-option, .js-true-search-option').css({'border-left':'0', 'background-color': 'transparent', 'color': 'black'})
    });
    $('.js-true-search-option').click(function(){
      $('.js-admin-section-scroll-config-container, .js-admin-section-filter-config-container').hide()
      $('.js-admin-section-search-config-container').show();
      $('.js-true-search-option').css({'border-left':'5px solid rgb(92, 106, 196)', 'background-color': 'white', 'color': 'rgb(92, 106, 196);'});
      $('.js-true-filter-option, .js-true-scroll-option').css({'border-left':'0', 'background-color': 'transparent', 'color': 'black'})
    });

    function debounce(func, wait, immediate) {
    	var timeout;
    	return function() {
    		var context = this, args = arguments;
    		var later = function() {
    			timeout = null;
    			if (!immediate) func.apply(context, args);
    		};
    		var callNow = immediate && !timeout;
    		clearTimeout(timeout);
    		timeout = setTimeout(later, wait);
    		if (callNow) func.apply(context, args);
    	};
    };

    $('.js-cart-btn').click(function(){
      var sizeID = parseInt($(this).parent().parent().find('select').val());
      window.cartField = this;
      $.ajax({
        type: 'POST',
        url: '/cart/add.js',
        data : { id: sizeID, quantity: 1 },
        dataType: 'json',
        success: function(data) {
          console.log(data);
          location.reload();
        },
        error: function(data) {
          $(window.cartField).parent().siblings().closest('.js-cart-error').html("* " + data.responseJSON.description)
        }
      });
    });

    $('.js-show-main-filter').click(function(){
      $('.js-main-filter-icon' ).toggleClass( 'filter-icon-minus' )
      if ($(".js-main-filter-icon").hasClass( "filter-icon-minus" )) {
        $('.box-2').css({'float': 'none'});
        $('.box-2').css({'width': '100%'});
        $('.js-main-container').hide("slide", { direction: "left" }, 1000);
      } else {
        $('.box-2').css({'width': '85%'});
        $('.box-2').css({'float': 'left'});
        $('.js-main-container').show("slide", { direction: "left" }, 1000);
      }
    });
    $('.js-show-brand-filter').click(function(){
      $('.js-brand-container').toggle();
      $('.js-brand-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-size-filter').click(function(){
      $('.js-size-container').toggle();
      $('.js-size-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-type-filter').click(function(){
      $('.js-type-container').toggle();
      $('.js-type-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-price-filter').click(function(){
      $('.js-price-container').toggle();
      $('.js-price-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });

    $('.openbtn').click(function() {
      $('#mySidenav').css({ 'width': `250px` });
      $('.app-container').css({'marginLeft' : "250px"});
      $('#shopify-section-cust-footer, .openbtn-container, .main-container').fadeOut()
    });

    $('.closebtn').click(function() {
      $('#mySidenav').css({ 'width': `0` });
      $('.app-container').css({'marginLeft' : "0"});
      $('#shopify-section-cust-footer, .openbtn-container, .main-container').show('slow')
    });

    $('.open-sort-btn').click(function() {
      $('#myLeftSidenav').css({ 'width': `250px` });
      $('.app-container').css({'marginLeft' : "250px"});
      $('#shopify-section-cust-footer, .openbtn-container, .main-container').fadeOut()
    });

    $('.close-sort-btn').click(function() {
      $('#myLeftSidenav').css({ 'width': `0` });
      $('.app-container').css({'marginLeft' : "0"});
      $('#shopify-section-cust-footer, .openbtn-container, .main-container').show('slow')
    });

    $('.js-new-syn-button').click(function(){
      var newField = $('.js-new-syn').first().clone()
      newField.children().find('.js-syn-field').val("")
      newField.appendTo( ".js-syn-container" );
    });

    $( "#sortable" ).sortable({
      update: function( event, ui ) {
        var ids = $("#sortable").children().map(function(){return this.id}).toArray();
        ids = ids.filter(String).join(",")
        $('.js-filter-order').val(ids)
      }
    });
    $( "#sortable" ).disableSelection();

    $('.quick-view-button').click(function() {
      // debugger;
      $(this).parent().siblings().first().show()
      // $(this).next().show();
      modalShowing = true;
      $('.blur-div, .quick-view-button, .box-1').toggleClass('fade-blur');
      $(body).css({'pointer-events': 'none'});
    });

    $('.model-close').click(function() {
      $(".the-modal").css({'top': '0'});
      $('.the-modal').hide();
      modalShowing = false;
      $('.blur-div, .quick-view-button, .box-1').toggleClass('fade-blur');
      $(body).css({'pointer-events': 'auto'});
    });

    // var modal = document.getElementById('myModal');
    //
    // // Get the button that opens the modal
    // var btn = document.getElementById("myBtn");
    //
    // // Get the <span> element that closes the modal
    // var span = document.getElementsByClassName("close")[0];
    //
    // // When the user clicks the button, open the modal
    // btn.onclick = function() {
    //   modal.style.display = "block";
    // }
    //
    // // When the user clicks on <span> (x), close the modal
    // span.onclick = function() {
    //   modal.style.display = "none";
    // }
    //
    // // When the user clicks anywhere outside of the modal, close it
    // window.onclick = function(event) {
    //   if (event.target == modal) {
    //     modal.style.display = "none";
    // }

    window.tabs = new function() {
      this.loadTabs = function() {

        $( ".product-image" ).mouseover(function() {
          $(this).css({ 'display': `none` });
          $(this).siblings().first().show()
        })
        $( ".product-image-two" ).mouseout(function() {
          $(this).css({ 'display': `none` });
          $(this).siblings().first().show()
        });
      }
      this.init = function(){}
    };
    window.tabs.loadTabs();
});
