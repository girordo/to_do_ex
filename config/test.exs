import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :to_do_mvc_ex, ToDoMvcEx.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "to_do_mvc_ex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :to_do_mvc_ex, ToDoMvcExWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "E6exTGu2gLIBchwcIQs3if8PnhRHJsb2KM6tb8FexKiY4Q1CWY760YUeWgiHQrqW",
  server: false

# In test we don't send emails.
config :to_do_mvc_ex, ToDoMvcEx.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
