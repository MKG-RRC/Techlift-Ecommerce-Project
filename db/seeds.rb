require "open-uri"
require "faker"
require "httparty"
require "csv"

puts "🧹 Cleaning database..."
OrderItem.destroy_all
Order.destroy_all
ProductCategory.destroy_all
Address.destroy_all
User.destroy_all
AdminUser.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all

# --------------------------------------------------------
# Provinces
# --------------------------------------------------------
puts "🏷  Seeding provinces with tax rates..."
[
  { name: "Alberta", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "British Columbia", gst: 0.05, pst: 0.07, hst: 0.0 },
  { name: "Manitoba", gst: 0.05, pst: 0.07, hst: 0.0 },
  { name: "New Brunswick", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Newfoundland and Labrador", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Nova Scotia", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Northwest Territories", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "Nunavut", gst: 0.05, pst: 0.0, hst: 0.0 },
  { name: "Ontario", gst: 0.0, pst: 0.0, hst: 0.13 },
  { name: "Prince Edward Island", gst: 0.0, pst: 0.0, hst: 0.15 },
  { name: "Quebec", gst: 0.05, pst: 0.09975, hst: 0.0 },
  { name: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0.0 },
  { name: "Yukon", gst: 0.05, pst: 0.0, hst: 0.0 }
].each do |attrs|
  Province.create!(attrs)
end

# --------------------------------------------------------
# 1.6 BASIC CATEGORIES
# --------------------------------------------------------
puts "📦 Creating base categories..."
categories = Category.create!([
  { name: "Desktop Monitors" },
  { name: "PC Systems" },
  { name: "Mechanical Keyboards" },
  { name: "Computer Mice" },
  { name: "Docking Stations" },
  { name: "Laptops" },
  { name: "Ergonomic Standing Desks" },
  { name: "Productivity Accessories and Cables" }
])

# --------------------------------------------------------
# 1.6 FAKER PRODUCTS (100 products)
# --------------------------------------------------------
puts "🛒 Creating 100 Faker products..."
100.times do
  category = categories.sample

  product = Product.create!(
    name:           Faker::Commerce.product_name,
    description:    Faker::Lorem.paragraph(sentence_count: 4),
    about:          Faker::Lorem.paragraph(sentence_count: 6),
    specifications: Faker::Lorem.paragraph(sentence_count: 8),
    price:          Faker::Commerce.price(range: 49..1999.0),
    is_new:         [true, false].sample,
    is_on_sale:     [true, false].sample
  )

  begin
    downloaded_file = URI.open("https://picsum.photos/seed/#{rand(10_000)}/800/800")
    product.images.attach(io: downloaded_file, filename: "faker_#{product.id}.jpg",
                          content_type: "image/jpg")
  rescue StandardError
    puts "Image failed for Faker product ##{product.id}"
  end

  product.categories << category
end

puts "🔥 Faker products done!"

# --------------------------------------------------------
# 1.7 SCRAPED DATA (CSV IMPORT)
# --------------------------------------------------------
scraped_csv_path = Rails.root.join("db/data/scraped_products.csv")

if File.exist?(scraped_csv_path)
  puts "🗂 Importing scraped products..."

  CSV.foreach(scraped_csv_path, headers: true) do |row|
    category_name = row["category"] || "Misc"
    category = Category.find_or_create_by!(name: category_name)

    product = Product.create!(
      name:           row["name"],
      description:    row["description"],
      price:          row["price"].to_f,
      about:          row["about"] || "N/A",
      specifications: row["specifications"] || "N/A",
      is_new:         false,
      is_on_sale:     false
    )

    product.categories << category
  end

  puts "✨ Scraped data import complete!"
else
  puts "⚠️ No scraped CSV found (db/data/scraped_products.csv)"
end

# --------------------------------------------------------
# 1.8 API IMPORT (DummyJSON)
# --------------------------------------------------------
puts "🌐 Fetching API products from DummyJSON..."

begin
  response = HTTParty.get("https://dummyjson.com/products?limit=50")
  api_products = response["products"]

  api_products.each do |p|
    category = Category.find_or_create_by!(name: p["category"].titleize)

    product = Product.create!(
      name:           p["title"],
      description:    p["description"],
      about:          "Imported from DummyJSON API.",
      specifications: "N/A",
      price:          p["price"],
      is_new:         false,
      is_on_sale:     false
    )

    begin
      downloaded_image = URI.open(p["thumbnail"])
      product.images.attach(
        io:           downloaded_image,
        filename:     "api_#{product.id}.jpg",
        content_type: "image/jpg"
      )
    rescue StandardError
      puts "API Image failed for: #{p['title']}"
    end

    product.categories << category
  end

  puts "🌍 API import complete!"
rescue StandardError => e
  puts "❌ API import failed: #{e.message}"
end

puts "🎉 ALL SEEDING DONE! (1.6 + 1.7 + 1.8 Completed)"
if Rails.env.development?
  AdminUser.find_or_create_by!(email: "admin@example.com") do |admin|
    admin.password = "password"
    admin.password_confirmation = "password"
  end
end
