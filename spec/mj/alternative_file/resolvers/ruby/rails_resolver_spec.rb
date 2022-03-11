# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RailsResolver do
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

  context "when handling rails controllers" do
    let(:controller) { "app/controllers/foos/bars_controller.rb" }
    let(:integration_test) { "test/integration/foos/bars_controller_test.rb" }
    let(:integration_spec) { "spec/integration/foos/bars_controller_spec.rb" }

    it "resolves controller integration test" do
      result = resolve(controller)

      expect(result).to include(create_candidate(integration_test, "integration_test"))
    end

    it "resolves controller integration spec" do
      result = resolve(controller)

      expect(result).to include(create_candidate(integration_spec, "integration_spec"))
    end

    it "resolves controller from integration test" do
      result = resolve(integration_test)

      expect(result).to include(create_candidate(controller, "controller"))
    end

    it "resolves controller from integration spec" do
      result = resolve(integration_spec)

      expect(result).to include(create_candidate(controller, "controller"))
    end
  end
end
