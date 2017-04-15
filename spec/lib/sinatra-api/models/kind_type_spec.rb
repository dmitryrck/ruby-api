require "sinatra-api_helper"

describe "KindType" do
  subject do
    KindType.new(kind: "movie")
  end

  it { is_expected.to be_valid }

  it "should not be valid without kind" do
    subject.kind = nil
    expect(subject).not_to be_valid
  end
end
