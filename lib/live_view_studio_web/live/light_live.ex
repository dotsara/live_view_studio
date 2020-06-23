defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  # Since we don't need params or session for this, we add the
  # underscore to ignore them. Neato.
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    # if we had multiple key/value pairs, we could pass in a
    # keyword list.
    # IO.inspect(socket)
    # what does the socket struct *look* like? Let's inspect!

    {:ok, socket}

    # the above will often be inline'd, but we're leaving it the way
    # it is for beginner-clarity. (:
    # because assign returns a socket and we need a socket as the 2nd
    # element of the tuple, so this works.
    # {:ok, assigns(socket, :brightness, 10)}
    # https://elixir-lang.org/getting-started/basic-types.html#tuples
  end

  def render(assigns) do
    # needs to return some rendered content
    ~L"""
      <h1>Front porch light</h1>
      <div id="light">
        <div class="meter">
          <span style="width: <%= @brightness %>%">
            <%= @brightness %>%
          </span>
        </div>
        <button phx-click="off">
          <img src="images/light-off.svg">
        </button>

        <form phx-change="update">
          <input type="range" min="0" max="100"
                 name="brightness" value="<%= @brightness %>">
        </form>

        <button phx-click="on">
          <img src="images/light-on.svg">
        </button>

        <p style="margin: .5rem;">
          <button phx-click="random">
            💃🏽 Randomize brightness! 💃🏽
          </button>
        </p>

      </div>
    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    brightness = String.to_integer(brightness)
    socket = assign(socket, brightness: brightness)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("random", _, socket) do
    socket = assign(socket, :brightness, Enum.random(0..100))
    {:noreply, socket}
  end
end
