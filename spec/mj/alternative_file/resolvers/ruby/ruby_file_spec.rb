# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RubyFile do
  subject(:file) { create("app/models/users/profile.rb") }

  def create(file)
    described_class.new(file)
  end

  it "extends current file" do
    expect(file).to be_a(Mj::AlternativeFile::CurrentFile)
  end

  describe "#class_path" do
    it "resolves name parts for rails models" do
      actual = create("app/models/users/profile.rb").class_path.to_s

      expect(actual).to eq("models/users/profile")
    end

    it "resolve name parts spec files" do
      actual = create("spec/models/users/profile_spec.rb").class_path.to_s

      expect(actual).to eq("models/users/profile")
    end

    it "resolve name parts minitest files" do
      actual = create("spec/models/users/profile_test.rb").class_path.to_s

      expect(actual).to eq("models/users/profile")
    end
  end
end
