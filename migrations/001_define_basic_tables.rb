Sequel.migration do
  transaction
  change do
    create_table(:animes) do
      primary_key :id
      String :name, size: 255, null: false, unique: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    create_table(:videos) do
      primary_key :id
      String :name, size: 255, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      foreign_key :anime_id, :animes, null: false, key: [:id]
      unique [:anime_id, :name]
    end

    create_table(:fingerprints) do
      primary_key :id
      Integer :timestamps, null: false, default: 0
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      File :image, null: false
      360.times do |i|
        Float "hue_#{i}".to_sym, null: false
      end
      foreign_key :video_id, :videos, null: false, key: [:id]
      unique [:video_id, :timestamps]
    end
  end
end
