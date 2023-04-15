# frozen_string_literal: true

require "active_job"
require "hanikamu/concerns/application-job"

module Hanikamu
  # This module extends ActiveSupport::Concern and adds async and retry
  # capabilities to a service object.
  # By including this module in a service class, the class gains the
  # ability to run asynchronously and retry failed jobs.

  # The module defines several class methods that allow you to define
  # the queue on which the service should run,
  # rescue from a specific error, and retry a specific error with a
  # specified wait time and number of attempts.

  # When this module is included in a class, a nested Async
  # class is defined that inherits from ApplicationJob.
  # This Async class allows the service to be run asynchronously
  # and provides retry capabilities for failed jobs.
  # The service can be run with the bang (!) version of the
  # call method or the non-bang version of the call method.

  # Call the service using SomeService::Async in order
  # to run it asynchronously.
  module Async
    extend ActiveSupport::Concern

    class_methods do
      # Use this method in your service class to define the queue in which it will run.
      # This method has the same syntax as ActiveJob's queue_as method.
      def queue_as(priority)
        self::Async.queue_as(priority)
      end

      # Use this method in your service class to rescue from
      # a specific error and perform some action.
      # This method has the same syntax as ActiveJob's
      # rescue_from method.
      def rescue_from(error, &block)
        self::Async(error, &block)
      end

      # Use this method in your service class to retry a
      # specific error with a certain wait time and number of attempts.
      # This method has the same syntax as ActiveJob's retry_on method.
      def retry_on(error, wait: 5, attempts: 5)
        self::Async.retry_on(error, wait: wait.seconds, attempts: attempts)
      end
    end

    def self.included(base)
      base.class_eval do
        const_set(
          :Async,
          Class.new(Hanikamu::ApplicationJob) do
            class << self
              # This method allows the service to be run asynchronously
              # with the bang (!) version of the call method.
              def call!(args = {})
                perform_later(args: args, bang: true)
              end

              # This method allows the service to be run asynchronously
              # with the non-bang version of the call method.
              def call(args = {})
                perform_later(args: args, bang: false)
              end
            end

            # This method is called when the job is performed.
            # If the bang parameter is true, the service will
            # be run with the call! method.
            # If the bang parameter is false, the service will
            # be run with the call method.
            def perform(args:, bang:)
              if bang
                self.class.module_parent.call!(args)
              else
                self.class.module_parent.call(args)
              end
            end
          end
        )
      end
    end
  end
end
