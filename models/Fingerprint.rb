class Fingerprint < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :video

  def fingerprint=(vec)
    360.times do |i|
      self.send("hue_#{i}=", vec[i])
    end
  end

  def fingerprint
    360.times.to_a.map do |i|
      self.send("hue_#{i}")
    end
  end
end
