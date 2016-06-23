# -*- encoding : utf-8 -*-
# require "digest/md5"

# class TeacherAvatar < BaseUploader

#   storage :qiniu

#   def version_names
#     %w( 220X178 320X240 480X320 )
#   end

#   def module_name 
#     'avatar'
#   end
#   def extension_white_list
#     %w( jpg jpeg gif png )
#   end
 
# end
require "digest/md5"
# require 'carrierwave/processing/mini_magick'

class TeacherAvatar < CarrierWave::Uploader::Base

  ##
  # Image manipulator library:
  #
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  storage :file


  def root; File.join(Padrino.root,"public/"); end

  def store_dir
    'upload/teacher_avatar'
  end

  def cache_dir
    Padrino.root("tmp")
  end

  version :thumb do
    process :resize_to_fill => [180, 180]
  end

  version :big do
    process :resize_to_fill => [800, 800]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "images/#{secure_token(16)}.png" if original_filename.present?
    # {file.extension}
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

end


# # encoding: utf-8
# require "digest/md5"
# require 'carrierwave/processing/mini_magick'

# class TeacherAvatar < CarrierWave::Uploader::Base
#   include CarrierWave::MiniMagick

#   storage :qiniu
#   self.qiniu_protocal = 'http'
#   self.qiniu_can_overwrite = true
  

#   # Override the directory where uploaded files will be stored.
#   def store_dir
#     puts "========self.qiniu_can_overwrite"
#     puts self.qiniu_can_overwrite
#     puts self.qiniu_can_overwrite
#     puts self.qiniu_can_overwrite
#     puts "======self.qiniu_can_overwrite"
#     "upload/screenshots/2014/04/#{model.id}"
#   end

#   # Add a white list of extensions which are allowed to be uploaded.
#   def extension_white_list
#     %w(jpg jpeg gif png)
#   end

#   def filename
#     "image.#{file.extension}" if original_filename.present?
#   end

# end