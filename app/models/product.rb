class Product < ActiveRecord::Base
 default_scopre order: 'title'
 validates :title, :description, :image_url, :presence => true
 validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
 validates :title, :uniqueness => true
 validates :image_url, :format => {
   :with => %r{\.(gif|jpe?g|png)$}i,
   :message => 'must be an URL for GIF, JPG, JPEG or PNG'
 }
end
