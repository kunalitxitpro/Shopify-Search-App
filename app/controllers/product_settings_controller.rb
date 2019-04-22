class ProductSettingsController < ApplicationController
  def edit
  end

  def update
    @product_setting = ProductSetting.find_by_id(params[:id])
    if @product_setting.update(product_setting_params)
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def product_setting_params
    params.require(:product_setting).permit(:image)
  end
end
