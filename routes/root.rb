ROOT_ROUTE = proc do
  get '' do
    erb :form
  end

  post 'search' do
    file = params[:file][:tempfile]
    processor = VideoHash.new
    img = Magick::Image.from_blob(file.read)[0]
    vec = processor.img_to_vec(img)

    @fingerprints = []

    Fingerprint.select_append {
      360.times.to_a.map do |i|
        vec[i].round(5) * Sequel["hue_#{i}".to_sym]
      end.reduce(:+).as(similarity)
    }.order(Sequel.desc(:similarity)).limit(10).each do |a|
      @fingerprints << a
    end
    erb :search
  end
end
