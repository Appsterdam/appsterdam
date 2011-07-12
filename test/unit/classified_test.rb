require File.expand_path("../../test_helper", __FILE__)

describe Classified, "concerning validation" do
  before do
    @classified = classifieds(:bike)
  end

  it "is invalid without offered/wanted" do
    @classified.offered = nil
    @classified.should.be.invalid
    @classified.errors[:offered].should.not.be.blank
    @classified.offered = false
    @classified.should.be.valid
  end

  it "is invalid without category" do
    @classified.category = ''
    @classified.should.be.invalid
    @classified.errors[:category].should.not.be.blank
  end

  it "is invalid without title" do
    @classified.title = nil
    @classified.should.be.invalid
    @classified.errors[:title].should.not.be.blank
  end

  it "is invalid without description" do
    @classified.description = nil
    @classified.should.be.invalid
    @classified.errors[:description].should.not.be.blank
  end

  it "is invalid without placer association" do
    @classified.placer = nil
    @classified.should.be.invalid
    @classified.errors[:placer_id].should.not.be.blank
  end
end

describe "A", Classified do
  before do
    @classified = classifieds(:bike)
  end

  it "returns whether or not it's a `wanted' ad" do
    @classified.should.not.be.wanted
    @classified.offered = false
    @classified.should.be.wanted
  end
end
