class Video < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :anime
  one_to_many :fingerprints
end
