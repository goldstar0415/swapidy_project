class ProductModel < ActiveRecord::Base
  attr_accessible :title, :comment, :category_id, :weight_lb, :product_model_attribute_ids, :image_ids
  
  belongs_to :category
  has_many :products

  has_many :product_model_attributes
  #has_many :category_attributes, :thought => :product_model_attributes
  
  has_many :images, :as => :for_object

  def for_buy?
    self.products.for_buy.count > 0
  end

  def for_sell?
    self.products.for_sell.count > 0
  end

  def main_image_url(type)
    main_image.photo.url(type)
  end
  
  def price_range_filter_content(range)
    result = " "
    result += model_filter_field if self.products.price_range(range).count > 0
    return result
  end
  
  def model_filter_field
    "attr_filter_model_#{self.id}"
  end
  
  def main_image
    return (images.where(:is_main => true).first || images.first) if images.count > 0
    return category.main_image
  end
    
  after_save :expired_fragment_caches
  after_destroy :expired_fragment_cache_destroy
  
  def expired_fragment_caches
    ActionController::Base.new.expire_fragment("homepage_category_#{category.id}_filter_attr") rescue nil
    ActionController::Base.new.expire_fragment("homepage_container_category_#{category.id}") rescue nil
  end
  
  def expired_fragment_cache_destroy
    ActionController::Base.new.expire_fragment("homepage_category_#{category.id}_filter_attr") rescue nil
    ActionController::Base.new.expire_fragment("homepage_container_category_#{category.id}") rescue nil
    products.each { |product| product.expired_fragment_caches }
  end
    

end
