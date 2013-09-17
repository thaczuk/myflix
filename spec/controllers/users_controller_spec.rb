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

      it "makes the user follow the invitor" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "joe doe"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be_true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "joe doe"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be_true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: {email: "joe@example.com", password: "password", full_name: "joe doe"}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "email sending" do
      it "sends out the email" do
        post :create, user: {full_name: 'Greg Thaczuk', password: 'pass', email: "greg@example.com"}
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "sends to the right recipient" do
        post :create, user: {full_name: 'Greg Thaczuk', password: 'pass', email: "greg@example.com"}
        message = ActionMailer::Base.deliveries.last
        message.to.should == ["greg@example.com"]
      end
      it "has the right content" do
        post :create, user: {full_name: 'Greg Thaczuk', password: 'pass', email: "greg@example.com"}
        message = ActionMailer::Base.deliveries.last
        message.body.should include("Welcome to MyFlix")
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

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'asfdfas'
      expect(response).to redirect_to expired_token_path
    end
  end
end