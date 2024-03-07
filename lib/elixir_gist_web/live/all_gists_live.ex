defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.Gists

  def mount(_, _, socket) do
    gists = Gists.list_gists()
    {:ok, assign(socket, gists: gists)}
  end

  def gist(assigns) do
    ~H"""
    <div
      class="justify-center px-28 w-full mb-20"
      style="cursor: pointer;"
      phx-click="select"
      phx-value-id={@gist.id}
    >
      <div class="flex justify-between mb-4">
        <div class="flex item-center ml-10">
          <img
            src="/images/user-image.svg"
            alt="Profile Image"
            class="round-image-padding w-8 h-8 mb-6"
          />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-emLavender-dark">
              <%= @current_user.email %><span class="text-white">/</span><%= @gist.name %>
            </div>
            <div class="text-lg text-white font-bold"><%= @gist.updated_at %></div>
            <p class="text-left text-sm text-white font-brand"><%= @gist.description %></p>
          </div>
        </div>
        <div class="flex item-center mr-10">
          <img src="/images/comment.svg" alt="Comment Count" class="h-6" />
          <div class="flex items-center text-white font-brand h-6 px-1">
            0
          </div>
          <img src="/images/BookmarkOutline.svg" alt="Save Count" class="h-6" />
          <div class="flex items-center text-white font-brand h-6 px-1">
            0
          </div>
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
    <%= @gist.markup_text %>
    </code></pre>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("select", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: id]}")}
  end
end
