class ApplicationController < ActionController::Base
  helper_method :sort_params_title


  private

  def sort_params_title(sort)
    case sort
    when 'title_ascending'
      'Alphabetically, A-Z'
    when 'price_ascending'
      'Price, low to high'
    when 'price_descending'
      'Price, high to low'
    when 'created_descending'
      'Date, new to old'
    when 'created_ascending'
      'Date, old to new'
    else
      "Sort"
    end
  end

end
