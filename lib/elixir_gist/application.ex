defmodule ElixirGist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElixirGistWeb.Telemetry,
      # Start the Ecto repository
      ElixirGist.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirGist.PubSub},
      # Start Finch
      {Finch, name: ElixirGist.Finch},
      # Start the Endpoint (http/https)
      ElixirGistWeb.Endpoint
      # Start a worker by calling: ElixirGist.Worker.start_link(arg)
      # {ElixirGist.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirGist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirGistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
