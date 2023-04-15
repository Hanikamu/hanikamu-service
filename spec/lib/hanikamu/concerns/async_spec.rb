# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanikamu::Async do
  let(:service) do
    class TestFooModule::Bar < Hanikamu::Service
      include Hanikamu::Async

      def call!
        "hola"
      end
    end
    TestFooModule::Bar
  end

  describe ".call" do
    it "adds a job to ActiveJob enqueued jobs list" do
      expect { service::Async.call }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
    end
  end

  describe ".call!" do
    it "adds a job to ActiveJob enqueued jobs list" do
      expect { service::Async.call! }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
    end
  end
end
