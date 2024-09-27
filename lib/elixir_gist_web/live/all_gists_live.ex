defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.Gists
  alias ElixirGistWeb.Utilities.DateFormat

  def mount(_params, _uri, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    gists = Gists.list_gists()

    socket =
      assign(socket,
        gists: gists
      )

    {:noreply, socket}
  end

  def gist(assigns) do
    ~H"""
    <div class="justify-center px-28 w-full mb-20">
      <div class="flex justify-between mb-4">
        <div class="flex items-center">
          <img src="/images/user-image.svg" alt="Profile Image" class="rounded-full w-8 h-8 mb-6" />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-emLavender-dark">
              <%= @gist.user_id %> <span class="text-white">/</span><%= @gist.name %>
            </div>
            <div class="font-bold text-white text-lg">
              <%= DateFormat.get_relative_time(@gist.updated_at) %>
            </div>
            <p class="text-sm text-white">
              <%= @gist.description %>
            </p>
          </div>
        </div>
        <div class="flex items-center">
          <img src="/images/comment.svg" alt="Comment Count" />
          <span class="text-white h-6 px-1">0</span>
          <img src="/images/BookmarkOutline.svg" alt="Bookmark Count" />
          <span class="text-white h-6 px-1">0</span>
        </div>
      </div>
      <div id="gist-wrapper" class="flex w-full">
        <textarea id="syntax-numbers" class="syntax-numbers rounded-bl-md rounded-tl-md" readonly></textarea>
        <div
          id="highlight"
          class="syntax-area w-full rounded-br-md rounded-tr-md"
          phx-hook="Highlight"
          data-name={@gist.name}
        >
          <pre><code class="language-elixir">
    <%= get_preview_text(@gist) %>
    </code></pre>
        </div>
      </div>
    </div>
    """
  end

  defp get_preview_text(gist) when not is_nil(gist.markup_text) do
    lines = gist.markup_text |> String.split("\n")

    if length(lines) > 10 do
      (Enum.take(lines, 9) ++ ["..."]) |> Enum.join("\n")
    else
      gist.markup_text
    end
  end

  defp get_preview_text(_gist), do: ""
end
