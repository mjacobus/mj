# frozen_string_literal: true

RSpec.describe Mj::AlternativeFile::Resolvers::Ruby::PackerResolver do
  subject(:resolver) { described_class.new }

  let(:component_class) { "app/components/foos/bar_component.rb" }
  let(:component_template) { "app/components/foos/bar_component.html.erb" }

  it "extends base class" do
    expect(resolver).to be_a(Mj::AlternativeFile::Resolvers::Base)
  end

  it "does not resolve any ruby file" do
    expect(resolve("foo.rb")).to be_empty
  end

  # Examples:
    # packages/foo/private/foo/bar/baz.rb
    # packages/foo/test/foo/bar/baz_test.rb
  
    # packages/foo/public/foo/bar.rb
    # packages/foo/test/foo/bar_test.rb

    # packages/foos/app/models/bar.rb
    # packages/foos/test/models/bar_test.rb

    # packages/foos/app/commands/foos/get_bars.rb
    # packages/foos/test/commands/foos/get_bars_test.rb

    # packages/foos/app/public/bar.rb
    # packages/foos/test/public/bar_test.rb
end
