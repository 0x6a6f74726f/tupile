defmodule Tupile.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Tupile.Boundary.ReportManager, [name: Tupile.Boundary.ReportManager]}
    ]

    opts = [strategy: :one_for_one, name: Tupile.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
