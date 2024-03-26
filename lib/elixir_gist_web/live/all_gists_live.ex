defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.{Gists, Utilities.DateFormat}

  def mount(_params, _uri, socket) do
    {:ok, socket}
  end
  
  def handle_params(params, _uri, socket) do
    page_number = Map.get(params, "page", "1") |> String.to_integer()
    paginated_gists = Gists.paginate_gists(page_number)

    socket =
      assign(socket,
        gists: paginated_gists.entries,
        total_pages: paginated_gists.total_pages,
        current_page: paginated_gists.page_number
      )

    {:noreply, socket}
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
            <div class="text-lg text-white font-bold">
              <%= DateFormat.get_relative_time(@gist.updated_at) %>
            </div>
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

  def handle_event("page", %{"page" => page}, socket) do
    {:noreply, push_patch(socket, to: ~p"/all?page=#{page}")}
  end

  def handle_event("next", _params, socket) do
    new_page = socket.assigns.current_page + 1

    if new_page <= socket.assigns.total_pages do
      {:noreply, push_patch(socket, to: ~p"/all?page=#{new_page}")}
    else
      {:noreply, socket}
    end
  end

  def handle_event("prev", _params, socket) do
    new_page = socket.assigns.current_page - 1

    if new_page >= 1 do
      {:noreply, push_patch(socket, to: ~p"/all?page=#{new_page}")}
    else
      {:noreply, socket}
    end
  end
end
