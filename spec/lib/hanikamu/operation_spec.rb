# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Operation do
  it "inherits from Hanikamu::Service" do
    expect(described_class.ancestors).to include(Hanikamu::Service)
  end

  it "includes Hanikamu::AsyncService module" do
    expect(described_class.included_modules).to include(Hanikamu::AsyncService)
  end

  it "includes Hanikamu::Form module" do
    expect(described_class.included_modules).to include(Hanikamu::Form)
  end
end
