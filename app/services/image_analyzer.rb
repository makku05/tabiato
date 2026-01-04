require "exifr/jpeg"

class ImageAnalyzer
  def self.call(image_file)
    # 一時ファイルからexif情報を解析
    gazo = EXIFR::JPEG.new(image_file.tempfile)

    # 位置情報がないときのnilを返す
    # return nil unless gazo.gps

    {
      latitude: gazo.gps&.latitude,
      longitude: gazo.gps&.longitude,
      taken_at: gazo.date_time_original
    }
  # jpeg以外はnilを返す
  rescue
    nil
  end
end
