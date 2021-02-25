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

- Service will implement ONLY a .call! public instance method.

- A Service.call! will success on it's task or will raise an error

- .call! will raise a set of known errors(validation, ...)

- Service.call will success on it's task returning a monadic Success reponse or will fail returning a monadic Failure

- .call will only catch a set of known Service Errors inheriting from Hanikamu::Service::WhiteListedError and it's implemented as a wrapper of .call!


#### Responsibilities

- Validation of the input/arguments types (dry-struct)


#### Requirements

- A Service should have a class comment describing the business logic performed.

- A Service should return an specific exception with an error message plus an error object if something fails. Ex.g.:
  - Sw::Bridge::GuardError

- A Service has maximum two public methods: `.call` or/and it's sibling `call!`
  - `.call!` always raises a specific exception in case of errors (ex.g. Sw::Bridge::InvalidSchemaError, or Sw::Bridge::InvalidFormError)

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
  class MyNewService < BaseService
    attributes :string_arg, Types::Strict::String

    def call!
      do_something
      do_something_else
      response_method
    end

    attr_reader :something, :something_else 

    Response = Struct(:nice_semantic_response, keyword_init: true)

    def do_something
      raise Error, "something is missing"  if string_args.empty?
      @something ||= FindSomeThingInDb.find(string_arg)
    end

    def do_something_else
      raise Error, "something else is missing" if string_args.empty?
      @something_else ||= something.else
    end

    def response_method
      # could be anything. In this example a Struct object.(return_only_the_banana)
      Response.new(nice_semantic_response: do_something_else)
    end
  end

  response = MyNewService.call!(string_arg: "Hola caracola")

  monadic_response = MyNewService.call(string_arg: "Hola caracola")
  monadic_response.success if monadic_response.success?

```
