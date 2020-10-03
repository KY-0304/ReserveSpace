class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [1920, 1280]

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [50, 50]
  end

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    if Rails.env.test?
      "uploads_#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def size_range
    1.kilobytes..5.megabytes
  end
end
