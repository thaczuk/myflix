require 'spec_helper'

describe VideosController do
  before { set_current_user }

  describe "GET show" do
    let(:video) { Fabricate(:video) }
    context "When user is not logged in" do
      before { clear_current_user }
      it "assigns the requested nil to the @video" do
        get :show, id: video
        assigns(:video).should == nil
      end

      it_behaves_like "requires sign in" do
        let(:action) { get :show, id: video }
      end
    end

    context "When user is logged in" do
      it "assigns the requested video to the @video" do
        get :show, id: video
        assigns(:video).should == video
      end

      it "render show template" do
        get :show, id: video
        response.should render_template :show
      end

      it "sets @reviews" do
        one_review = Fabricate( :review, video: video )
        another_review = Fabricate( :review, video: video )
        get :show, id: video
        assigns(:reviews).should =~ [ one_review, another_review ]
      end
    end
  end

    describe "POST search" do
    let(:video) { Fabricate(:video) }
    context "When user is not logged in" do
      it_behaves_like "requires sign in" do
        let(:action) { post :search, search_term: video.title }
      end
    end

    context "When user is logged in" do
      it "return nil if search term does not match" do
        post :search, search_term: "outlier"
        assigns(:videos).should == []
      end
      it "return video if the search term exactly matches" do
        post :search, search_term: video.title
        assigns(:videos).should == [video]
      end

      it "return videos if the search term partially matches" do
        south_park = Fabricate(:video, title: 'South Park')
        south_pole = Fabricate(:video, title: 'South Pole')
        post :search, search_term: 'outh'
        assigns(:videos).should eq( [south_park, south_pole] )
      end

      it "renders the search template" do
        post :search, search_term: video.title
        response.should render_template :search
      end
    end
  end
end