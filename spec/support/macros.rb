
def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def create_a_queue_video
  set_current_user
  post :create, video_id: video.id
end

def clear_current_user
  session[:user_id] = nil
end

