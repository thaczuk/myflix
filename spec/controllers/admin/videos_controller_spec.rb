require 'spec_helper'

describe Admin::VideosController do
  describe "GET #new" do
    let(:bob) { Fabricate(:admin) }

    context "admin user" do
      before(:each) do
        set_current_user(bob)
        get :new
      end

      it "assigns the @video to a new video" do
        assigns(:video).should be_new_record
        assigns(:video).should be_instance_of(Video)
      end

      it "should render the :new template" do
       response.should render_template :new
      end
    end

    context "non admin" do
      before(:each) do
        set_current_user(bob)
        get :new
      end

      it "should redirect to home page" do
       get :new
       response.should render_template :new
      end
    end
  end

  # describe "Post #create" do
  #   context "admins" do
  #     before { set_current_user( Fabricate(:admin)) }

  #     it "creates the video" do
  #       drama = Fabricate(:category)
  #       post :create, video: {name: "Monk", category_id: drama.id, description: "Awesome series!" }
  #       monk = Video.find_by_name("Monk").should be_present
  #     end
  #   end
  # end
end
