# ElixirBankAccount

This is a simple Elixir application that use Plug.

We are supposed to write a simple program that allows us to manage bank accounts of our customers. For example we should be able to deposit money, withdrawal money and check our account balance.

## Requirements

* Manage multiple `account`, one for each customer.
* For each account we can perform these actions:
  * create a new account
  * delete an account
  * check current balance
  * deposit money
  * withdrawal money

## Get dependencies

```
mix deps.get
```

## How to run tests

```
mix test
```

## How to run application

```
iex -S mix
```

## Available APIs

* Restful at `http://localhost:4000/`
* GraphQL at `http://localhost:5000/`

### How to use the Restful API

_there is a simple authorization mechanism right now, so in order to make authenticated request you have to specificy the HTTP header `auth: joe`_

**create an account**

```
curl -X "POST" -H "auth: joe" http://localhost:4000/accounts/[account_name]
```

**delete an account**

```
curl -X "DELETE" -H "auth: joe" http://localhost:4000/accounts/[account_name]
```

**get current balance**

```
curl -H "auth: joe" http://localhost:4000/accounts/[account_name]
```

**deposit amount**

```
curl -X "PUT" -H "auth: joe" http://localhost:4000/accounts/[account_name]/deposit/[amount]
```

**withdraw amount**

```
curl -X "PUT" -H "auth: joe" http://localhost:4000/accounts/[account_name]/withdraw/[amount]
```

### How to use the GraphQL API

_there is no authentication mechanism for this API at the moment_

You can use any GraphiQL client (take a look at the browsers extensions).

**create an account**

```
mutation CreateAccount {
  createAccount(name: "joe") {
    name
  }
}
```

**delete an account**

```
mutation DeleteAccount {
  deleteAccount(name: "joe") {
    name
  }
}
```

**get current balance**

```
{
  account(name: "joe") {
    balance
  }
}
```

**deposit amount**

```
mutation Deposit {
  deposit(name: "joe", amount: 1000) {
    balance
  }
}
```

**withdraw amount**

```
mutation Withdraw {
  withdraw(name: "joe", amount: 100) {
    balance
  }
}
```
