class ProductsController < ApplicationController
  def index
    @categories = Category.all

    @products = Product.all

    # Search
    if params[:search].present?
      keyword = "%#{params[:search]}%"
      @products = @products.where("name ILIKE ?", keyword)
    end

    # Category filter
    if params[:category_id].present?
      @products = @products.joins(:categories)
                           .where(categories: { id: params[:category_id] })
    end

    # Pagination
    @products = @products.page(params[:page]).per(9)
  end

  def show
    @product = Product.find(params[:id])
  end
end
