# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Commands::ListCommandHandler do
  subject(:handler) { described_class.new(resolvers: resolvers) }

  let(:command) { Mj::AlternativeFile::Commands::ListCommand.new(file, options) }
  let(:file) { "a.file.rb" }
  let(:options) { {} }
  let(:handle) { handler.handle(command) }

  before do
    resolver1 = mock_resolver do |_file|
      ["model.rb", "model"]
    end

    resolver2 = mock_resolver do |_file|
      ["controller.rb", "controller"]
    end

    resolver3 = mock_resolver do |file|
      [file, "file"]
    end

    resolvers.add(resolver1)
    resolvers.add(resolver2)
    resolvers.add(resolver3)
  end

  it "sorts candidates by path" do
    paths = handle.map(&:path)

    expected = [
      "a.file.rb",
      "controller.rb",
      "model.rb"
    ]

    expect(paths).to eq(expected)
  end
end
