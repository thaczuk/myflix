require 'spec_helper'

describe QueueVideosController do
  describe "GET index" do
    it "sets @queue_videos to the queue items of the logged in user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_video1 = Fabricate(:queue_video, user: alice)
      queue_video2 = Fabricate(:queue_video, user: alice)
      get :index
      expect(assigns(:queue_videos)).to match_array([queue_video1, queue_video2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to login_path
    end
  end

end