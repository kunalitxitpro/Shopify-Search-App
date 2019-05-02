require 'rake'

class ProductSettingsController < ApplicationController
  def edit
  end

  def update
    @product_setting = ProductSetting.find_by_id(params[:id])
    if @product_setting.update(product_setting_params)
      set_synonyms
      redirect_to test_admins_path
    else
      redirect_to test_admins_path
    end
  end

  def sync
    %x[rake jobs:add_and_update_products]
    redirect_to test_admins_path
  end

  private

  def synonym_params
    params[:product_setting][:product_synonyms].permit!.to_h
  end

  def set_synonyms
    synonym_params[:synonym].each_with_index do |synonym, i|
      value = synonym_params[:value][i]
      id = synonym_params[:id][i] rescue nil
      if id.present?
        ps = ProductSynonym.find(id)
        if synonym.blank? || value.blank?
          ps.destroy
        else
          ps.update(synonym: synonym, value: value)
        end
      else
        ProductSynonym.create(product_setting_id: params[:id], synonym: synonym, value: value)
      end
    end
  end


  def product_setting_params
    params.require(:product_setting).permit(:image, :number_of_items_to_load, :filter_order, :include_out_of_stock_products, :related_search_on, :autoscroll_on, :load_more_text)
  end
end
