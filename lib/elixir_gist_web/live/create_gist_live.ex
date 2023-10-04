defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view
  import Phoenix.HTML.Form
  alias ElixirGist.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        form: to_form(Gists.change_gist(%Gist{}))
      )

    {:ok, socket}
  end
end
