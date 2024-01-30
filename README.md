# hanikamu-service

[![ci](https://github.com/Hanikamu/hanikamu-service/actions/workflows/ci.yml/badge.svg)](https://github.com/Hanikamu/hanikamu-service/actions/workflows/ci.yml)

## Services

#### Definition
Services enforce a pattern design as service objects.

#### Objectives
- Adherence to the Single Responsibility Principle for simplified testing.
- Establishment of a uniform pattern for service design to prevent divergent practices.
- Removal of business logic from models to maintain clean architecture.
- Isolation of business logic for focused testing.
- Comprehensive understanding of domain models and business transactions.
- Emphasis on clear intent rather than mere data structuring.


#### Principles

- Subclasses of the service should implement a main `.call!` instance method.

- A `Service.call!` will success on it's task or will raise an error

- `.call!` will raise a predefined set of errors (e.g., validation errors).

- `Service.call` should either successfully return a Success response or a Failure response in a monadic format.

- `.call` will catch only specific Service Errors inheriting from Hanikamu::Service::WhiteListedError and it's implemented as a wrapper of `.call!`


#### Responsibilities

- Validation of the input/arguments types (dry-struct)


#### Requirements

- A Service should have a class comment describing the business logic performed.

- A Service should return an specific exception with an error message plus an error object if something fails. Ex.g.:
  - MyApplication::Errors::GuardError

- A Service has maximum two public methods: `.call` or/and it's sibling `call!`
  - `.call!` always raises a specific exception in case of errors (ex.g. MyApplication::Errors::InvalidSchemaError, or MyApplication::Errors::InvalidFormError)

  - `.call` always returns a dry-rb monad, either Success or Failure (https://dry-rb.org/gems/dry-monads/).

- A Service should return something meaningful, like an object or a struct in case of success.

#### Suggestions
  
  - When asking for a banana return only the banana
    https://www.johndcook.com/blog/2011/07/19/you-wanted-banana/ 

###### Schema Validation
Checks if the input types are valid.
- Validates input types (e.g., ensuring job_id is an integer and required).
- Errors can be corrected by the client passing different input types to the service.

#### Example Usage

```ruby
  module Types
    include Dry.Types()
  end

  class MyNewService < Hanikamu::Service
    attribute :string_arg, Types::Strict::String

    def call!
      do_something
      do_something_else

      response nice_semantic_response: do_something_else
    end

    def do_something
      raise Error, "something is missing"  if string_arg.empty?
      # @something ||= FindSomeThingInDb.find(string_arg)
    end

    def do_something_else
      raise Error, "something else is missing" if string_arg.empty?
      "You said: #{string_arg}"
    end
  end

  response = MyNewService.call!(string_arg: "Hola caracola")

  monadic_response = MyNewService.call(string_arg: "Hola caracola")
  monadic_response.success if monadic_response.success?
```


#### Configuration

If you wish to include additional error classes to the existing whitelisted_errors array, which is used for determining which errors should result in a Failure response when calling services without a bang (e.g., SomeService.call), you can do so by appending these classes to the whitelisted_errors list in an initializer.

```ruby

# in initializer config/initializers/hanikamu_service

Hanikamu::Service.configure do |config|
  config.whitelisted_errors = [SomeError]
end

```

#### Using docker

  Rename Makefile.example to Makefile
  - `make build` for building the image
  - `make shell` to get a shell console with the ruby environment
  - `make console` get a ruby console
  - `make rspec` run the specs
