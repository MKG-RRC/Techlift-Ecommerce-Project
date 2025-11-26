class ProductsController < ApplicationController
  def index
    @products = Product.includes(:categories, images_attachments: :blob)
                       .order(created_at: :desc)
                       .page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end
