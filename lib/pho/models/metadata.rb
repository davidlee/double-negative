class Pho::Metadata

  MINI_EXIF_TOOL = MiniExiftool


  attr_reader :path

  class UnsupportedFileType < ArgumentError; end

  def initialize(path)
    raise ArgumentError.new(path.inspect) unless path.is_a?(String)
    @path = path
  end

  def data
    @data ||= MiniExiftool.new(path).to_hash
  end

  def creation_time
    if !@data && jpeg?
      # this is a LOT faster, but only supports JPEG files.
      Exif::Data.new(path)[:date_time_original]
    else
      data.fetch('DateTimeOriginal')
    end
  end

  def jpeg?
    %w(jpg jpeg).include?(File.extname(path).downcase.delete('.'))
  end

end

