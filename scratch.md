Remember this:

* introduce the use of [typespecs and behaviours](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html)

# DOING

# TODO

* find a way to expose the two APIs (restful and the graphql) by using only one server
* move all test helpers in `test_helpers.exs` ??
* use the existing authorization mechanism to authorize the graphql API
* move the module `Http.Router` to `Http.Rest.Router`
* replace the tests for the 403 with a single test for the restful api
* as an `admin` I can transfer money from an existing account to another

# NICE TO HAVE

* use float instead of integer for amount
* **EXTRA:** as a `customer` I can create more than one bank account

# DONE

* document in the `readme` how to play with the existing restful api and graphql
* graphQL API: expose the withdraw feature
* graphQL API: expose the deposit feature
* graphQL API: expose the check_balance feature
* graphQL API: expose the delete account feature
* graphQL API: handle the case where account already exists when we try to create it
* disable DEBUG information
* expose a graphql API to create a bank account
  * use mock to test the collaboration between graphQL api and `Bank.AdminMock`
* introduce [Macros](http://hugoribeira.com/DRYing-Elixir-Tests-With-Macros/) to automatically generate tests for the user not authenticated scenario
  * try to extract a macro for the forbidden 403 http requests
* introduce an authorization mechanism to authorize the HTTP requests
* do not use the pipe operator for `Bank.AdminMock` in the tests
* add the `verify!` to all the tests that use the `Bank.AdminMock`
* expose the `withdraw` through an HTTP API
* `Bank.Admin.deposit` and `Bank.Admin.withdraw` behaves differently (asimmetry)
* use [`Mox`](https://hexdocs.pm/mox/Mox.html) instead of [`Mock`](https://github.com/jjh42/mock)
* run a webserver at the application startup
* `Bank.Admin.deposit` should handle non numeric values for amount (won't fix)
   is a responsability of the router to parse and validate the parameters
* expose the `deposit` through an HTTP API
* expose the `check_balance` through an HTTP API
* expose the `delete_account` through an HTTP API
* expose the `create_account` through an HTTP API
