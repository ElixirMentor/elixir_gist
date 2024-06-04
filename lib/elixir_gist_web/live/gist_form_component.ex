defmodule ElixirGistWeb.GistFormComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="create" phx-change="validate" phx-target={@myself}>
        <div class="justify-center px-28 w-full space-y-4 mb-10">
          <.input type="hidden" field={@form[:id]} value={@id} />
          <.input
            field={@form[:description]}
            placeholder="Gist description.."
            autocomplete="off"
            phx-debounce="blur"
          />
          <div>
            <div class="flex p-2 items-center bg-emDark rounded-t-md border">
              <div class="w-[300px] mb-2">
                <.input
                  field={@form[:name]}
                  placeholder="Filename including extension..."
                  autocomplete="off"
                  phx-debounce="blur"
                />
              </div>
            </div>
            <div id="gist-wrapper" class="flex w-full" phx-update="ignore">
              <textarea id="line-numbers" class="line-numbers rounded-bl-md" readonly>
          <%= "1\n" %>
        </textarea>
              <div class="flex-grow">
                <.input
                  type="textarea"
                  field={@form[:markup_text]}
                  class="textarea w-full rounded-br-md"
                  placeholder="Insert code..."
                  autocomplete="off"
                  phx-debounce="blur"
                  phx-hook="UpdateLineNumbers"
                />
              </div>
            </div>
          </div>
          <div class="flex justify-end">
            <%= if @id == :new do %>
              <.button class="create_button" phx-disable-with="Creating...">Create gist</.button>
            <% else %>
              <.button class="create_button" phx-disable-with="Updating...">Update gist</.button>
            <% end %>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    if params["id"] == "new" do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_gist(params, socket) do
    case Gists.update_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end
end
