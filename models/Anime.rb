class Anime < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :videos
end
