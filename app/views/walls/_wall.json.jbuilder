json.extract! wall, :id, :name, :slug, :expireDate, :user_id, :created_at, :updated_at
json.url wall_url(wall, format: :json)
