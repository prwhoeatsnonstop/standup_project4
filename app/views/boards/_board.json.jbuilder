json.extract! board, :id, :accomplishment, :challenges, :task, :resources, :user_id, :created_at, :updated_at
json.url board_url(board, format: :json)