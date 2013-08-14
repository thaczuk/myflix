require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    it "should set @user" do
      get :new
      assigns(:user).should be_new_record
      assigns(:user).should be_instance_of(User)
    end

    it "should render :new" do
      get :new
      response.should render_template :new
    end
  end

describe "POST #create" do
  context "with valid user input" do
      it "should create the user" do
        post :create, user: {full_name: 'Greg Thaczuk', password: 'pass', email: "greg@example.com"}
        User.first.full_name.should == "Greg Thaczuk"
      end

      it "redirect to sign in path" do
        post :create, user: {full_name: 'Greg Thaczuk', password: 'pass', email: "greg@example.com"}
        response.should redirect_to sign_in_path
      end

      it "sets the success flash message" do
        post :create, user: {full_name: 'Greg Thaczuk', password: 'pass', email: "greg@example.com"}
        flash[:success].should == "You are registered. Please sign in."
      end
    end

    context "with invalid user inputs" do
      it "does not create the user" do
        post :create, user: {password: 'pass', email: "greg@example.com"}
        User.count.should == 0
      end

      it "renders the :new template" do
        post :create, user: {password: 'pass', email: "greg@example.com"}
        response.should render_template :new
      end
    end
  end
end

