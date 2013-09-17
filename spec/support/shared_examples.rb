shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples "tokenable" do
  it "generates a random token when the user is created" do
    expect(object.token).to be_present
  end
end