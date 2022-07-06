# hanikamu-service

[![ci](https://github.com/Hanikamu/hanikamu-service/actions/workflows/ci.yml/badge.svg)](https://github.com/Hanikamu/hanikamu-service/actions/workflows/ci.yml)

## Services

#### Definition
Services enforce a pattern design as service objects.

#### Why?
- We want SRP(single responsibility classes) for easier testing.

- We want to have a common pattern on our service design preventing a fragmentation of patterns.

- We want to avoid business logic in our models.

- We want to test our business logic in isolation.

- We want a complete overview over our domain model and business logic transactions

- We want to express intent over data structure.


#### Principles

- Subclasses of the service should implement a main `.call!` instance method.

- A `Service.call!` will success on it's task or will raise an error

- `.call!` will raise a set of known errors(validation, ...)

- `Service.call` will success on it's task returning a monadic Success reponse or will fail returning a monadic Failure

- `.call` will only catch a set of known Service Errors inheriting from Hanikamu::Service::WhiteListedError and it's implemented as a wrapper of `.call!`


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

###### Schema
Checks if the input types are valid.
E.g. job_id is required and of type integer
Errors can be corrected by the client passing different input types to the operation

#### Example


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

#### Using docker

  Rename Makefile.example to Makefile
  - `make build` for building the image
  - `make shell` to get a shell console with the ruby environment
  - `make console` get a ruby console
  - `make rspec` run the specs


  
