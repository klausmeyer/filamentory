defmodule Filamentory.Repo do
  use Ecto.Repo,
    otp_app: :filamentory,
    adapter: Ecto.Adapters.Postgres
end
