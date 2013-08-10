require 'spec_helper'

describe Category do
  it "saves itself" do
     category = Category.new(name: "Comedy")
     category.save
     Category.first.name.should == "Comedy"
     expect(Category.first).to eq(category)
  end

it { should have_many(:videos) }
end