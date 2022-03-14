# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RailsResolver do
  subject(:resolver) { described_class.new }

  def resolve(file)
    described_class.new.resolve(Mj::AlternativeFile::CurrentFile.new(file))
  end

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  context "with rails models" do
    it "resolves from spec file" do
      result = resolve("spec/models/users/profile_spec.rb")

      expect(result).to include(create_candidate("app/models/users/profile.rb", "model"))
    end

    it "resolves rspec file" do
      result = resolve("app/models/users/profile.rb")

      expect(result).to include(create_candidate("spec/models/users/profile_spec.rb", "spec"))
    end

    it "resolves minitest file" do
      result = resolve("app/models/users/profile.rb")

      expect(result).to include(create_candidate("test/models/users/profile_test.rb", "minitest"))
    end
  end

  context "with rails other app/folders" do
    it "resolves from spec file" do
      result = resolve("spec/services/users/profile_spec.rb")

      expect(result).to include(create_candidate("app/services/users/profile.rb", "model"))
    end

    it "resolves rspec file" do
      result = resolve("app/services/users/profile.rb")

      expect(result).to include(create_candidate("spec/services/users/profile_spec.rb", "spec"))
    end

    it "resolves minitest file" do
      result = resolve("app/services/users/profile.rb")

      expect(result).to include(create_candidate("test/services/users/profile_test.rb", "minitest"))
    end
  end

  context "with files that belong in lib" do
    it "resolves from spec file" do
      result = resolve("spec/services/users/profile_spec.rb")

      expect(result).to include(create_candidate("lib/services/users/profile.rb", "lib"))
    end

    it "resolves rspec file" do
      result = resolve("lib/services/users/profile.rb")

      expect(result).to include(create_candidate("spec/services/users/profile_spec.rb", "spec"))
    end

    it "resolves minitest file" do
      result = resolve("lib/services/users/profile.rb")

      expect(result).to include(create_candidate("test/services/users/profile_test.rb", "minitest"))
    end
  end
end
