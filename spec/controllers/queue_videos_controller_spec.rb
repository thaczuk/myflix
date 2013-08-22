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

  describe 'POST create' do
    context "logged-in user" do
      let!(:video) { Fabricate(:video) }

      it "redirect to the my queue page" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue item" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(QueueVideo.count).to eq(1)
      end

      it "creates the queue associated to the video" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video.id
        expect(QueueVideo.first.video).to eq(video)
      end

      it "creates the queue associated to the current user" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        post :create, video_id: video.id
        expect(QueueVideo.first.user).to eq(alice)
      end

      it "does not create the queue if it is already queued" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        monk = Fabricate(:video)
        Fabricate(:queue_video, video: monk, user: alice)
        post :create, video_id: monk.id
        expect(alice.queue_videos.count).to eq(1)
      end

      it "puts the video to the last position" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        monk = Fabricate(:video)
        Fabricate(:queue_video, video: monk, user: alice)
        south_park = Fabricate(:video)
        post :create, video_id: south_park.id
        south_park_queue_item = QueueVideo.where(video_id: south_park.id, user_id: alice.id).first
        expect(south_park_queue_item.position).to eq(2)
      end
    end
    context "not logged-in user" do
      it "redirect to root path" do
        post :create, video_id: 5
        expect(response).to redirect_to login_path
      end
    end
  end
end