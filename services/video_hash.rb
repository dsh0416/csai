class VideoHash
  def initialize(resolution='320x180')
    @resolution = resolution
  end

  def img_to_vec(img)
    hue_count = [0] * 360
    img.each_pixel do |pixel, c, r|
      hue = pixel.to_hsla[0].to_i
      hue_count[hue] += 1
    end
    Vector[*hue_count].normalize.to_a
  end

  def file_to_vec(filename)
    img = Magick::Image.read(filename)[0]
    img_to_vec(img)
  end

  def build(path, video)
    movie = FFMPEG::Movie.new(path)
    movie.screenshot("./tmp/screenshot_%d.jpg", { vframes: 100_000, frame_rate: '1/6', resolution: @resolution }, validate: false, preserve_aspect_ratio: :width)
    shots = (movie.duration /  6.0).to_i
    shots.times do |i|
      vec = file_to_vec("./tmp/screenshot_#{i + 1}.jpg")
      Fingerprint.find_or_create(
        timestamps: i * 6,
        video: video,
      ) do |f|
        f.fingerprint = vec
        f.image = Sequel.blob(File.read(filename))
      end
    end
    Dir.glob('./tmp/*.jpg').each { |file| File.delete(file)}
  end
end
