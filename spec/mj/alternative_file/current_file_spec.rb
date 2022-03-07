# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::CurrentFile do
  subject(:current_file) { described_class.new(file_path) }

  let(:file_path) { "spec/fixtures/current_file.txt" }

  describe "#initialize" do
    it "sets the file path" do
      expect(current_file.path.to_s).to eq(file_path)
    end
  end

  it "converts to string" do
    expect(current_file.to_s).to eq(file_path)
  end

  describe "#extension" do
    it "returns the extension when it exists" do
      expect(current_file.extension).to eq("txt")
    end

    it "returns nil when extension is not set" do
      current_file = described_class.new("Dockerfile")

      expect(current_file.extension).to be_nil
    end
  end

  it "returns #file_without_extension" do
    expect(current_file.path_without_extension.to_s).to eq("spec/fixtures/current_file")
  end

  it "returns file_name" do
    expect(current_file.name).to eq("current_file.txt")
  end

  it "#trim_slashes" do
    path = described_class.new("/app/models//foo/").trim_slashes.to_s

    expect(path.to_s).to eq("app/models/foo")
  end
end
