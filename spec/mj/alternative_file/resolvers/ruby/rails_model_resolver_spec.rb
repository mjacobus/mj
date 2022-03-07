# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RailsModelResolver do
  subject(:resolver) { described_class.new }

  def resolve(file)
    described_class.new.resolve(Mj::AlternativeFile::CurrentFile.new(file))
  end

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "resolves from spec file" do
    result = resolve("spec/models/users/profile_spec.rb")

    expect(result).to include(create_candidate("app/models/users/profile.rb", "model"))
  end

  it "resolves rspec file" do
    result = resolve("app/models/users/profile.rb")

    expect(result).to include(create_candidate("spec/models/users/profile_spec.rb", "rspec"))
  end

  it "resolves minitest file" do
    result = resolve("app/models/users/profile.rb")

    expect(result).to include(create_candidate("test/models/users/profile_test.rb", "minitest"))
  end
end
