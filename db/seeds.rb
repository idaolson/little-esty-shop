# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
BulkDiscount.destroy_all

BulkDiscount.create!(name: "Spooky Showdown", discount: 0.20, threshold: 2, merchant_id: 1)
BulkDiscount.create!(name: "Memorial Day Bonanza", discount: 0.30, threshold: 5, merchant_id: 1)
BulkDiscount.create!(name: "Wacky Wednesday", discount: 0.10, threshold: 8, merchant_id: 1)
BulkDiscount.create!(name: "Oops, We Discounted Again!", discount: 0.50, threshold: 9, merchant_id: 1)
