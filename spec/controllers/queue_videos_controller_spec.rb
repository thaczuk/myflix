require 'spec_helper'

describe QueueVideosController do
  describe "GET index" do
    it "sets @queue_videos to the queue items of the logged in user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_video1 = Fabricate(:queue_video, user: alice)
      queue_video2 = Fabricate(:queue_video, user: alice)
      get :index
      expect(assigns(:queue_videos)).to match_array([queue_video1, queue_video2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    context "logged-in user" do
      let!(:video) { Fabricate(:video) }

      it "redirect to the my queue page" do
        create_a_queue_video
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue item" do
        create_a_queue_video
        expect(QueueVideo.count).to eq(1)
      end

      it "creates the queue associated to the video" do
        create_a_queue_video
        expect(QueueVideo.first.video).to eq(video)
      end

      it "creates the queue associated to the current user" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, video_id: video.id
        expect(QueueVideo.first.user).to eq(alice)
      end

      it "does not create the queue if it is already queued" do
        alice = Fabricate(:user)
        set_current_user(alice)
        monk = Fabricate(:video)
        Fabricate(:queue_video, video: monk, user: alice)
        post :create, video_id: monk.id
        expect(alice.queue_videos.count).to eq(1)
      end

      it "puts the video to the last position" do
        alice = Fabricate(:user)
        set_current_user(alice)
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

  describe "DELETE destroy" do
    context 'logged-in user' do
      let!(:user) { Fabricate(:user) }
      before { set_current_user }

      it "redirects to the my_queue page" do
        queue_video = Fabricate(:queue_video)
        delete :destroy, id: queue_video.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queued video" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_video = Fabricate(:queue_video, user: alice)
        delete :destroy, id: queue_video.id
        expect(QueueVideo.count).to eq(0)
      end

      it "normalizes the remaining queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_video1 = Fabricate(:queue_video, user: alice, position: 1)
        queue_video2 = Fabricate(:queue_video, user: alice, position: 2)
        delete :destroy, id: queue_video1.id
        expect(QueueVideo.first.position).to eq(1)
      end

      it "does not delete the queued video of a different user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(alice)
        queue_video = Fabricate(:queue_video, user: bob)
        delete :destroy, id: queue_video.id
        expect(QueueVideo.count).to eq(1)
      end
    end

    context 'logged-out user' do
      it_behaves_like "requires sign in" do
       let(:action) { delete :destroy, id: 3 }
      end
    end
  end

  describe 'POST update_queue' do
    context "with valid input" do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_video1) { Fabricate(:queue_video, user: alice, position: 1, video: video) }
      let(:queue_video2) { Fabricate(:queue_video, user: alice, position: 2, video: video) }

      before do
        set_current_user(alice)
      end

      it "redirects to the my queue page" do
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 2}, {id: queue_video2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue videos" do
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 2}, {id: queue_video2.id, position: 1}]
        expect(alice.queue_videos).to eq([queue_video2, queue_video1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 3}, {id: queue_video2.id, position: 2}]
        expect(alice.queue_videos.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid input" do
      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_video1) { Fabricate(:queue_video, user: alice, position: 1, video: video) }
      let(:queue_video2) { Fabricate(:queue_video, user: alice, position: 2, video: video) }

      before do
        set_current_user(alice)
      end
      it "redirect to my_queue path" do
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 2.8}, {id: queue_video2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the error flash with eror message" do
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 2.8}, {id: queue_video2.id, position: 1}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue videos" do
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 3}, {id: queue_video2.id, position: 2.1}]
        expect(queue_video1.reload.position).to eq(1)
      end
  end

    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do
       let(:action) { post :update_queue, queue_videos: [{id: 2, position: 3}, {id: 5, position: 2}] }
      end
    end

    context "with queue videos not belonging to the current user" do
      it "does not change position of other's queue videos" do
        alice = Fabricate(:user)
        set_current_user(alice)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_video1 = Fabricate(:queue_video, user: bob, position: 1, video: video)
        queue_video2 = Fabricate(:queue_video, user: alice, position: 2, video: video )
        post :update_queue, queue_videos: [{id: queue_video1.id, position: 3}, {id: queue_video2.id, position: 2}]
        expect(queue_video1.reload.position).to eq(1)
      end
    end
  end
end