use Mix.Config

config :bank, accounts_administrator: Bank.Admin
config :bank, authentication_service: Http.JoeAuthorizationService
