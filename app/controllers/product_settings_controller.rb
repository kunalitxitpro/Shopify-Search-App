class ProductSettingsController < ApplicationController
  def edit
  end

  def update
    @product_setting = ProductSetting.find_by_id(params[:id])
    if @product_setting.update(product_setting_params)
      redirect_to test_admins_path
    else
      redirect_to test_admins_path
    end
  end

  private

  def product_setting_params
    params.require(:product_setting).permit(:image, :number_of_items_to_load)
  end
end
