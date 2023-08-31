defmodule ElixirGistWeb.Layouts.App do
  alias Phoenix.LiveView.JS

  def toggle_dropdown_menu do
    JS.toggle(
      to: "#dropdown_menu",
      in: {"transition ease-out duration-100", "transform opacity-0 translate-y-[-10%]", "transform opacity-100 translate-y-0"},
      out: {"transition ease-in duration-75", "transform opacity-100 translate-y-0", "transform opacity-0 translate-y-[-10%]"}
      )
  end

end
