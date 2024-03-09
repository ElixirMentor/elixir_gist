defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.Gists

  def mount(_, _, socket) do
    gists = Gists.list_gists()
    {:ok, assign(socket, gists: gists)}
  end

  def gist(assigns) do
    ~H"""
    <div class="justify-center px-28 w-full mb-20" phx-click="select" phx-value-id={@gist.id}>
      <div class="flex justify-between mb-4">
        <div class="flex items-center ml-10">
          <img src="/images/user-image.svg" alt="Profile Image" class="rounded-full w-8 h-8 mb-6" />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-emLavender-dark">
              <%= @current_user.email %><span class="text-white">/</span><%= @gist.name %>
            </div>
            <div class="text-lg text-white font-bold"><%= @gist.updated_at %></div>
            <p class="text-sm text-white"><%= @gist.description %></p>
          </div>
        </div>
        <div class="flex items-center mr-10">
          <img src="/images/comment.svg" alt="Comment Count" class="h-6" />
          <span class="text-white h-6 px-1">0</span>
          <img src="/images/BookmarkOutline.svg" alt="Save Count" class="h-6" />
          <span class="text-white h-6 px-1">0</span>
        </div>
      </div>
      <div class="justify-center px-10 mb-10">
        <div id="gist-wrapper" class="flex w-full">
          <textarea
            id={"line-numbers-#{@gist.id}"}
            class="gist-preview-numbers rounded-bl-md rounded-tl-md"
            readonly
          >
          </textarea>
          <div
            id={"highlight-#{@gist.id}"}
            class="gist-preview-area w-full rounded-br-md rounded-tr-md"
            phx-hook="Highlight"
            data-name={@gist.name}
            data-id={@gist.id}
          >
            <pre><code class="language-elixir">
    <%= get_preview_text(@gist) %>
    </code></pre>
          </div>
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
      Enum.join(lines, "\n")
    end
  end

  defp get_preview_text(_gist), do: ""

  def handle_event("select", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: id]}")}
  end
end
