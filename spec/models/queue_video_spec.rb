require 'spec_helper'

describe QueueVideo do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "should return video title" do
      video = Fabricate(:video, title: 'Monk')
      queue_video = Fabricate(:queue_video, video: video)
      expect(queue_video.video_title).to eq('Monk')
    end
  end
  describe "#rating" do
    it "should return rating from the review when the review exists" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_video = Fabricate(:queue_video, user: user, video: video)
      expect(queue_video.rating).to eq(4)
    end
    it "returns nil if the user does not have review on the video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_video = Fabricate(:queue_video, user: user, video: video)
      expect(queue_video.rating).to be_nil
    end
  end

  describe "#rating=" do
    it "changes the rating of the review if the rating is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_video = Fabricate(:queue_video, user: user, video: video)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_video.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "clears the rating of the review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_video = Fabricate(:queue_video, user: user, video: video)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_video.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it "creates a review with the rating if the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_video = Fabricate(:queue_video, user: user, video: video)
      queue_video.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      category = Fabricate(:category, name: "comedies")
      video = Fabricate(:video, category: category)
      queue_video = Fabricate(:queue_video, video: video)
      expect(queue_video.category_name).to eq("comedies")
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category, name: "comedies")
      video = Fabricate(:video, category: category)
      queue_video = Fabricate(:queue_video, video: video)
      expect(queue_video.category).to eq(category)
    end
  end
end