Remember this:

* introduce the use of [typespecs and behaviours](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html)
* run a webserver at the application startup
* introduce a `Bank.Admin.Mock` module

# DOING

# TODO

* expose the `withdraw` through an HTTP API
* use [Mox](https://hexdocs.pm/mox/Mox.html) instead of Mock
* use float instead of integer for amount
* as an Admin I can transfer money from an existing account to another
* introduce somekind of authorization mechanism
* as a customer I can create more than one bank account

# DONE

* `Bank.Admin.deposit` should handle non numeric values for amount (won't fix)
   is a responsability of the router to parse and validate the parameters
* expose the `deposit` through an HTTP API
* expose the `check_balance` through an HTTP API
* expose the `delete_account` through an HTTP API
* expose the `create_account` through an HTTP API
