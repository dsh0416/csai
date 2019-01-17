if Anime.empty?
  Anime.create(name: 'Kemono Friends')
  Anime.create(name: 'Bakuman')
end

processor = VideoHash.new
Dir['./static/*.mp4'].each do |file|
  a, b = file.split('/')[-1].split('_')
  anime = Anime.find(id: a.to_i)
  video = Video.find_or_create(name: b, anime: anime)
  fingerprints = processor.build(file, video)
end
