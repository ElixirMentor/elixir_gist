defmodule ElixirGistWeb.Utilities.DateFormat do
  def get_relative_time(datetime) do
    {:ok, relative_time} = Timex.format(datetime, "{relative}", :relative)
    relative_time
  end
end
