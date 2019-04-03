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

$( document ).ready(function() {
    var PageNumber = 2;
    var running = false;

    $(window).bind('scroll', function() {
        if($(window).scrollTop() >= $('.product-container').offset().top + $('.product-container').outerHeight() - window.innerHeight) {
          if(running == false){
            $('.loading-gif').fadeIn();
            running = true;
            $.ajax({
              type: "GET",
              url: "/all_products?page=" + PageNumber,
              data: $(this).serialize(),
              success: function(response) {
                $('.loading-gif').fadeOut();
                $('.js-all-products').append(response.productsPartial);
              }
            });
            PageNumber = PageNumber + 1
            setTimeout(function(){running = false}, 300);
          }
        }
    });
});
