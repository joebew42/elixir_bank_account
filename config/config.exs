use Mix.Config

config :plug, validate_header_keys_during_test: true

import_config "#{Mix.env}.exs"
