class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # space詳細ページ用のサイズ
  process resize_to_fill: [700, 500]

  # サムネイル用のサイズ
  version :thumb do
    process resize_to_fill: [200, 200]
  end

  # アップロード時のサムネイル
  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [50, 50]
  end

  storage :file

  # テスト環境では独自のパスで保存する設定
  def store_dir
    if Rails.env.test?
      "uploads_#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  # 許容するファイル拡張子
  def extension_whitelist
    %w(jpg jpeg png)
  end

  # ファイルサイズを1KB〜5MBに制限
  def size_range
    1.kilobytes..5.megabytes
  end

  # spaceのimageがnilの時、表示する画像
  # def default_url(*args)
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
