require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    it "should render the :new template" do
      get :new
      response.should render_template :new
    end
  end

  describe "DELETE #destroy" do
    it "should set session to nil after logout" do
      delete :destroy
      session[:user_id].should be_nil
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy }
    end
  end

  describe "POST #create" do
    before {
      @user = User.create(email: "greg@example.com", password: "pass", full_name:  "Greg Thaczuk")
    }
    context "valid inputs" do
      it "stores the user id in sesson" do
        post :create, {email: "greg@example.com", password: "pass"}
        session[:user_id].should == @user.id
      end
      it "redirects to the video path" do
        post :create, {email: "greg@example.com", password: "pass"}
        response.should redirect_to home_path
      end
    end

    context "Only password input" do
      it "does not create a session" do
        post :create, { password: "greg" }
        session[:user_id].should be_nil
      end

      it_behaves_like "requires sign in" do
        let(:action) { post :create, { password: "greg" } }
      end
    end

    context "Incorrect email" do
      it "does not create session" do
        post :create, { password: "pass", email: "greg@example"}
        session[:user_id].should be_nil
      end

      it_behaves_like "requires sign in" do
        let(:action) { post :create, { password: "pass", email: "greg@example"} }
      end
    end
  end
end