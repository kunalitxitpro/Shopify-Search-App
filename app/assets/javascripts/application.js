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
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require foundation
//= require_tree

$(function(){ $(document).foundation(); });

$(document).on('turbolinks:load', () => {
    var PageNumber = 2;
    var running = false;
    var canLoadMore = true;

    $(window).bind('scroll', function() {
        if($(window).scrollTop() >= $('.product-container').offset().top + $('.product-container').outerHeight() - window.innerHeight) {
          if(running == false){
            running = true;
            $('.js-product-group:hidden').slice(0, 12).fadeIn('slow');
            if ($('.js-product-group:hidden').length <= 1 && canLoadMore){
              $('.loading-gif').fadeIn();
              $.ajax({
                type: "GET",
                url: "/apps/index?&filter=true&page=" + PageNumber + Window.paramUrl + "&last_prod_id=" + window.LastProductID,
                data: $(this).serialize(),
                success: function(response) {
                  if(response.productCount != 36){
                    canLoadMore = false;
                  }
                  $('.loading-gif').fadeOut();
                  var productID = response.lastProductID;

                  if($('.js-product-id-' + productID).length){
                    canLoadMore = false;
                  }else {
                    $('.js-all-products').append(response.productsPartial);
                  }
                }
              });
              PageNumber = PageNumber + 1
            }
            setTimeout(function(){running = false}, 300);
          }
        }
    });
    var searchField = $('.search-form').children('.form-group').children('.form-control')
    $('.search-form').append("<div class='plop'></div>")

    $(searchField).keyup(function() {
      var dInput = this.value;
      if(dInput.length > 2){
        console.log(dInput);
        $('.plop').html('');

        $.ajax({
          type: "GET",
          url: "/apps/index?&search=true&query=" + dInput,
          data: $(this).serialize(),
          success: function(response) {
            $('.plop').html(response.searchPartial);
            $('.plop').show('slow');
          }
        });
      }else{
        $('.plop').hide();
      }
    });

    $('.js-show-main-filter').click(function(){
      $('.js-main-container').toggle("slide");
      $('.main-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-brand-filter').click(function(){
      $('.js-brand-container').toggle();
      $('.brand-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-size-filter').click(function(){
      $('.js-size-container').toggle();
      $('.size-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-type-filter').click(function(){
      $('.js-type-container').toggle();
      $('.type-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });
    $('.js-show-price-filter').click(function(){
      $('.js-price-container').toggle();
      $('.price-filter-icon' ).toggleClass( 'filter-icon-minus' )
    });

    $( ".product-image" ).mouseover(function() {
      $(this).css({ 'display': `none` });
      $(this).siblings().first().show()
    })
    $( ".product-image-two" ).mouseout(function() {
      $(this).css({ 'display': `none` });
      $(this).siblings().first().show()
    });
});
