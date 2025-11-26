require "open-uri"
require "faker"

puts "🧹 Cleaning database..."
Product.destroy_all
Category.destroy_all

puts "📦 Creating categories..."
categories = Category.create!([
  { name: "Laptops" },
  { name: "Monitors" },
  { name: "Keyboards" },
  { name: "Standing Desks" }
])

puts "🛒 Creating 100 products..."
100.times do
  category = categories.sample

  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 4),
    about: Faker::Lorem.paragraph(sentence_count: 6),
    specifications: Faker::Lorem.paragraph(sentence_count: 8),
    price: Faker::Commerce.price(range: 49..1999.0),
    is_new: [true, false].sample,
    is_on_sale: [true, false].sample
  )

  product.categories << category

  # Attach random tech-like image
  random_image_url = "https://picsum.photos/seed/#{rand(10000)}/800/800"
  downloaded_file = URI.open(random_image_url)

  product.images.attach(
    io: downloaded_file,
    filename: "seed_image_#{product.id}.jpg",
    content_type: "image/jpg"
  )
end

puts "✅ Seeding finished!"
