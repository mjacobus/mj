# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::ViewComponentResolver do
  subject(:resolver) { described_class.new }

  let(:component_class) { "app/components/foos/bar_component.rb" }
  let(:component_template) { "app/components/foos/bar_component.html.erb" }

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "does not resolve any ruby file" do
    expect(resolve("foo.rb")).to be_empty
  end

  it "resolves template from component class" do
    result = resolve(component_class)

    expect(result).to include(create_candidate(component_template, "component_template"))
  end

  it "resolves component_class from template" do
    result = resolve(component_template)

    expect(result).to include(create_candidate(component_class, "component_class"))
  end
end
