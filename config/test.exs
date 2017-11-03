use Mix.Config

config :bank, accounts_administrator: Bank.AdminMock
config :bank, authentication_service: Http.AuthorizationServiceMock
