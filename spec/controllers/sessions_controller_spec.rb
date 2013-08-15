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

    it "redirect_to to login path" do
      delete :destroy
      response.should redirect_to login_path
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
      it "redirects to the login page" do
        post :create, {password: "greg" }
        response.should redirect_to login_path
      end
    end

    context "Incorrect email" do
      it "does not create session" do
        post :create, { password: "pass", email: "greg@example"}
        session[:user_id].should be_nil
      end
      it "should redirect_to to login page" do
        post :create, { password: "pass", email: "greg@example"}
        response.should redirect_to login_path
      end
    end
  end
end











