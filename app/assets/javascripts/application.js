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
    var PageNumber = 2;
    var running = false;
    var canLoadMore = true;

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

                    if($('.js-product-id-' + productID).length){
                      canLoadMore = false;
                    }else {
                      $('.js-all-products').append(response.productsPartial);
                      window.tabs.loadTabs();
                    }
                  }
                });
                PageNumber = PageNumber + 1
              }
              setTimeout(function(){running = false}, 300);
            }
          }
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

    $('.js-show-main-filter').click(function(){
      $('.js-main-container').toggle("slide");
      $('.js-main-filter-icon' ).toggleClass( 'filter-icon-minus' )
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
      $('.js-new-syn').first().clone().appendTo( ".js-syn-container" );
    });

    $( "#sortable" ).sortable({
      update: function( event, ui ) {
        var ids = $("#sortable").children().map(function(){return this.id}).toArray();
        ids = ids.filter(String).join(",")
        debugger;
        $('.js-filter-order').val(ids)
      }
    });
    $( "#sortable" ).disableSelection();
    $('.search-box').addClass('main-search').removeClass('search-box').removeClass('search');
    $('.search-box, .search-form').hide();
    $('.main-search').addClass('collapsed');
    $('.main-search').append("<div class='js-search-results'></div>")
    $('.main-search').append("<input class='main-search-input' type='text' placeholder='Search...' ></input><a class='main-search-button'></a>");


    // $('.main-search').css({ 'display': 'block' });

    $(".main-search-button").click(function() {
      if ($('#main-search-id').hasClass("collapsed")) {
        $('.main-search-button').css({'background-color': '#8FD4F5'});
        $('.main-search-input').focus();
      } else {
        $('.main-search-button').css({'background-color': '#FEFEFE'});
      }

      if ($('.main-search-input').val() != "") {
        $('#main-search-id a').attr("href", '#');
      } else {
        $('#main-search-id a').removeAttr("href");
      }
      $(this).parent(".main-search").toggleClass("collapsed");
    });

    var searchField = $('.search-form').children('.form-group').children('.form-control')
    if(searchField){

      $(".main-search-input").keyup(debounce(function(){
         $('.js-search-results').show('slow');
         var dInput = this.value;
         if(dInput.length >= 1){
          console.log(dInput);
          $('.js-search-results').html("<div class='search-loading-gif'></div>");
          $('.search-loading-gif').fadeIn();
          $.ajax({
            type: "GET",
            url: "/apps/index?&search=true&query=" + dInput,
            data: $(this).serialize(),
            success: function(response) {
              $('.js-search-results').html(response.searchPartial);
              $('.js-search-results').show('slow');
            }
          });
        }else{
          $('.js-search-results').hide();
        }
      },500));
    }

    $('.quick-view-button').click(function() {
      $('.the-modal').show();
    });

    $('.model-close').click(function() {
      $('.the-modal').hide();
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
