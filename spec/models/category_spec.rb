require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "should return no videos if there is no video in the category" do
      porn = Category.create(name: "Porn")
      expect(porn.recent_videos.count).to eq(0)
    end
    it "should return all the videos in a category if there are less than 6" do
      comedies = Category.create(name: "Comedy")
      family_guy = Video.create(title: "Family guy",
                                            description: "redneck comedy",
                                            category: comedies, created_at: 1.day.ago)
      south_park = Video.create(title: "South Park",
                                            description: "weird comedy",
                                            category: comedies)
      expect(comedies.recent_videos.count).to eq(2 )
    end
    it "should return only 6 videos
        if there are more than 6 in a category" do
      comedies = Category.create(name: "Comedy")
      7.times { Video.create(title: "Family guy",
                                            description: "redneck comedy",
                                            category: comedies) }
      expect(comedies.recent_videos.count).to eq(6)
    end
    it "should return reverse chronological order" do
      comedies = Category.create(name: "Comedy")
      family_guy = Video.create(title: "Family guy",
                                            description: "redneck comedy",
                                            category: comedies, created_at: 1.day.ago)
      south_park = Video.create(title: "South Park",
                                            description: "weird comedy",
                                            category: comedies)
      expect(comedies.recent_videos).to eq( [south_park, family_guy] )
    end
    it "should return the most recent 6 videos" do
      comedies = Category.create(name: "Comedy")
      6.times { Video.create(title: "Family guy",
                                            description: "redneck comedy",
                                            category: comedies) }
      yesterday = Video.create(title: "Old show",
                                            description: "old comedy",
                                            category: comedies, created_at: 1.day.ago)
      expect(comedies.recent_videos).not_to include(yesterday)
    end
  end
end