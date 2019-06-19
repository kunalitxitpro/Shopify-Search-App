(function () {

  function LoadSearch() {
    //  start Search
    console.log("search loaded..")
    var isMobile;
    var x = window.matchMedia("(max-width: 930px)")
    MediaFunction(x) // Call listener function at run time
    x.addListener(MediaFunction) // Attach listener function on state changes

    function MediaFunction(x) {
      if (x.matches) {
         isMobile = true;
      } else {
         isMobile = false;
      }
    }

    $('.search-form').attr('action', '/apps/products');
    $('.search-form').attr('autocomplete', 'off');

    if (isMobile == true) {
      $('.search-form').append("<div class='js-mobile-search-results'></div>");
      $('.search_input_mob').keyup(debounce(function(){
        $('.js-mobile-search-results').show('slow');
        var dInput = this.value;
        if(dInput.length >= 1){
        console.log(dInput);
        $('.js-mobile-search-results').html("<div class='search-loading-gif-container'><div class='search-loading-gif'></div></div>");
        $('.search-loading-gif').fadeIn();
        $.ajax({
          type: "GET",
          url: "/apps/products?&search=true&query=" + dInput,
          data: $(this).serialize(),
          success: function(response) {
          $('.js-mobile-search-results').html(response.searchPartial);
          $('.js-mobile-search-results').show('slow');
          }
        });
        }else{
        $('.js-mobile-search-results').hide();
        }
      },500));

    } else {
      $('.search-form').append("<div class='js-search-results'></div>");
      var desktopInput = $('#search').children().first();
      $(desktopInput).focus(function() {
       var dInput = this.value;
       if(dInput.length >= 1){
          $('.js-search-results').fadeIn('slow')
       }
      }).blur(function() {
          $('.js-search-results').fadeOut('slow')
      });

      $(desktopInput).keyup(debounce(function(){
         $('.js-search-results').show('slow');
         var dInput = this.value;
         if(dInput.length >= 1){
          console.log(dInput);
          $('.js-search-results').html("<div class='search-loading-gif-container'><div class='search-loading-gif'></div></div>");
          $('.search-loading-gif').fadeIn();
          $.ajax({
            type: "GET",
            url: "/apps/products?&search=true&query=" + dInput,
            data: $(this).serialize(),
            success: function(response) {
              $('.js-search-results').html(response.searchPartial);
              $('.js-search-results').show('slow');

              $( ".popular-search-sub-container" ).hover(function() {
                $(this).children().first().css({'background-image': 'url("https://s3.amazonaws.com/shopify-app-prod/search-white.svg")'})
              });

              $( ".popular-search-sub-container" ).mouseout(function() {
                $(this).children().first().css({'background-image': 'url("https://s3.amazonaws.com/shopify-app-prod/search.svg")'})
              });
            }
          });
        }else{
          $('.js-search-results').hide();
        }
      },500));
    }

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
  //  end Search
  }
  // LoadSearch();
  // $.ajax({
  //   type: "GET",
  //   url: "/apps/products?&search_on_query=true",
  //   data: $(this).serialize(),
  //   success: function(response) {
  //     if(response.search_on == true){
  //       LoadSearch();
  //     }
  //   }
  // });
  $(document).on('turbolinks:load', () => {
    LoadSearch();
    // $.ajax({
    //   type: "GET",
    //   url: "/apps/products?&search_on_query=true",
    //   data: $(this).serialize(),
    //   success: function(response) {
    //     if(response.search_on == true){
    //       LoadSearch();
    //     }
    //   }
    // });
  });
})();
