require "sinatra-api_helper"

describe "Title" do
  subject do
    Title.new(
      title: "Logan",
      kind_id: kind_type.id,
      production_year: 2017
    )
  end

  let(:kind_type) do
    KindType.create(kind: "Kind#1")
  end

  it { is_expected.to be_valid }

  it "should not be valid without title" do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it "should not be valid without kind_id" do
    subject.kind_id = nil
    expect(subject).not_to be_valid
  end

  it "should not be valid without production_year" do
    subject.production_year = nil
    expect(subject).not_to be_valid
  end
end
