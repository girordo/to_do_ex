defmodule ToDoMvcEx.Repo do
  use Ecto.Repo,
    otp_app: :to_do_mvc_ex,
    adapter: Ecto.Adapters.Postgres
end
