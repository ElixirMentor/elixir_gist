defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
