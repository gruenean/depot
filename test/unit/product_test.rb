require 'test_helper'

class ProductTest < ActiveSupport::TestCase
   fixtures :products
   # No empty attributes
   test "product attributes must not be empty" do
     product = Product.new
     assert product.invalid?
     assert product.errors[:title].any?
     assert product.errors[:description].any?
     assert product.errors[:price].any?
     assert product.errors[:image_url].any?
   end

   # Positive price
   test "product price must be positive" do
     product = Product.new(:title => 'Harry Potter',
                           :description => 'Harry Potter ant the chamber of secrets',
			   :image_url => 'tcos.jpeg')
     product.price = -1
     assert product.invalid?
     assert_equal "must be greater than or equal to 0.01",
       product.errors[:price].join('; ')

     product.price = 0
     assert product.invalid?
     assert_equal "must be greater than or equal to 0.01",
       product.errors[:price].join('; ')

     product.price = 1
     assert product.valid?
   end

   # valid image url
   def new_product(image_url)
     Product.new(:title => 'Harry Potter', 
                 :description => 'Harry Potter ant the chamber of secrets',
                 :price => 1,
                 :image_url => image_url)
   end
   
   test "image_url" do
      ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg ruedi.jpeg ruedi.JPEG http://a.b.c/x/y/z/fred.gif }
      bad = %w{ fred.doc fred.gif/more fred.gif.more }
  
      ok.each do |name|
         assert new_product(name).valid?, "#{name} shouldn't be invalid"
      end
      bad.each do |name|
         assert new_product(name).invalid?, "#{name} shouldn't be valid"
      end
   end

   test "product is not valid without unique title" do
     product = Product.new(:title => products(:ruby).title,
                           :description => "fooblah", 
                           :price => 1, 
                           :image_url => "fred.gif") 
   assert !product.save
     assert_equal "has already been taken", product.errors[:title].join('; ')
   end
end
