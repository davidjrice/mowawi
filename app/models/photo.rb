class Photo < ActiveRecord::Base
  belongs_to :place
  has_attachment :content_type => :image,
                 :path_prefix => 'public/system/photos',  
                 :storage => :file_system, 
                 :max_size => 500.kilobytes,
                 :resize_to => '320x240>',
                 :thumbnails => { :thumb => '100x100>' }

                 
  validates_as_attachment
  validates_presence_of :place_id, :user_id
  
  before_thumbnail_saved do |photo, thumbnail|
    thumbnail.place_id = photo.place_id
    thumbnail.user_id = photo.user_id
  end
  
end
