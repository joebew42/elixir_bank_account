Remember this:

* introduce the use of [typespecs and behaviours](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html)

# DOING

* introduce [Macros](http://hugoribeira.com/DRYing-Elixir-Tests-With-Macros/) to automatically generate tests for the user not authenticated scenario
 * try to extract a macro for the forbidden 403 http requests

# TODO

* as an `admin` I can transfer money from an existing account to another

# NICE TO HAVE

* use float instead of integer for amount
* **EXTRA:** as a `customer` I can create more than one bank account

# DONE

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
