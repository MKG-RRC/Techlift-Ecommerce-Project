# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @categories = allowed_categories

    @products = Product.joins(:categories)
                       .where(categories: { name: allowed_category_names })
                       .distinct

    # Search
    if params[:search].present?
      keyword = "%#{params[:search]}%"
      @products = @products.where('products.name ILIKE ? OR products.description ILIKE ?', keyword, keyword)
    end

    # Category filter
    if params[:category_id].present?
      category = @categories.find_by(id: params[:category_id])
      @products = @products.joins(:categories)
                           .where(categories: { id: category.id }) if category
    end

    # Special filters
    case params[:filter]
    when 'sale'
      @products = @products.on_sale
    when 'new'
      @products = @products.recently_added
    end

    # Pagination
    @products = @products.page(params[:page]).per(9)
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def allowed_category_names
    [
      "Desktop Monitors",
      "PC Systems",
      "Mechanical Keyboards",
      "Computer Mice",
      "Docking Stations",
      "Laptops",
      "Ergonomic Standing Desks",
      "Productivity Accessories and Cables",
      "Monitors",
      "Standing Desks",
      "Keyboards",
      "Mice"
    ]
  end

  def allowed_categories
    Category.where(name: allowed_category_names).order(:name)
  end
end
