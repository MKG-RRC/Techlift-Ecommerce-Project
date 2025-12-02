require "ostruct"

class PagesController < ApplicationController
  def about
    @page = find_page("about") || OpenStruct.new(
      title: "About TechLift Store",
      content: <<~TEXT
        We are a Canadian tech retailer focused on bringing carefully curated hardware to builders, gamers, and creators.
        Every product is vetted by our in-house team, and we prioritize fast shipping within Canada.
      TEXT
    )
  end

  def contact
    @page = find_page("contact") || OpenStruct.new(
      title: "Contact Us",
      content: <<~TEXT
        Have a question about an order or a product? Reach us by email or phone—we're here to help.
      TEXT
    )
  end

  def home
    @featured_products = Product.limit(6).includes(:categories, images_attachments: :blob)
    @categories = Category.limit(6)
  end

  private

  def find_page(slug)
    PageContent.find_by(slug: slug)
  end
end
