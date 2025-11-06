# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::RailsSubfolderResolver do
  subject(:resolver) { described_class.new }

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  context "with component file" do
    it "resolves from component file" do
      result = resolve("apps/api/app/components/attribute_component.rb")

      expect(result).to include(
        create_candidate("apps/api/spec/components/attribute_component_spec.rb", "spec")
      )
    end

    it "resolves from spec file" do
      result = resolve("apps/api/spec/components/attribute_component_spec.rb")

      expect(result).to include(
        create_candidate("apps/api/app/components/attribute_component.rb", "model")
      )
    end
  end
end
