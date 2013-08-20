require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe "#search_by_title" do
    before :each do
      @video = Video.create(title: "South Park", description: "A comedy")
    end

    it "should return empty array when nothing is found" do
      expect(Video.search_by_title( 'xxx' )).to eq( [] )
    end

    it "should return a video if the search keyword matches exactly" do
      expect(Video.search_by_title( 'South Park' )).to eq( [@video] )
    end

    it "should return videos if the keyword is found in multiple videos" do
      pole = Video.create(title: "South Pole", description: "An adventure")
      expect(Video.search_by_title( 'South' )).to include( @video, pole )
    end
  end

  describe "#average_ratings" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}

    it "should return 0 if there is no review" do
      expect(video.average_ratings).to eq 0
    end
    it "should return the average review if there are any reviews" do
      video.reviews << Fabricate(:review, body: "aaa", rating: 2)
      video.reviews << Fabricate(:review, body: "aaa", rating: 5)
      expect(video.average_ratings).to eq(3.5)
    end
  end
end