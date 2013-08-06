require 'spec_helper'

describe Video do
  it "saves itself" do
     video = Video.new(title: "South Park",
                                  description: "A comedy",
                                  small_cover_url: "tmp/south_park.jpg",
                                  large_cover_url: "tmp/monk_large.jpg",
                                  category_id: 1)
     video.save
     Video.first.title.should == "South Park"
  end

  it { should have_one(:category) }

end