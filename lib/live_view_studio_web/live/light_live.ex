defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  # Since we don't need params or session for this, we add the
  # underscore to ignore them. Neato.
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    # if we had multiple key/value pairs, we could pass in a
    # keyword list.
    {:ok, socket}

    # the above will often be inline'd, but we're leaving it the way
    # it is for beginner-clarity. (:
    # because assign returns a socket and we need a socket as the 2nd
    # element of the tuple, so this works.
    # {:ok, assigns(socket, :brightness, 10)}
    # https://elixir-lang.org/getting-started/basic-types.html#tuples
  end
end
