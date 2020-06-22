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

        <button phx-click="down">
          <img src="images/down.svg">
        </button>

        <button phx-click="up">
          <img src="images/up.svg">
        </button>

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

  # the phx-click attribute is what LiveView calls a binding; this one
  # is binding a click event to the button an off event is sent via the
  # websocket to the LightLive process.

  # the second element is meta data we don't care about just now, so
  # we'll ignore it for now
  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  # def handle_event("up", _, socket) do
  #   # because we want to bump the brightness each time the button is
  #   # clicked, we need to get the current brightness value
  #   socket = update(socket, :brightness, &(&1 + 10))
  #   {:noreply, socket}
  # end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  # def handle_event("down", _, socket) do
  #   socket = update(socket, :brightness, &(&1 - 10))
  #   {:noreply, socket}
  # end

  def handle_event("random", _, socket) do
    socket = assign(socket, :brightness, Enum.random(0..100))
    {:noreply, socket}
  end

  # updated up & down events using the floor/ceiling from the
  # exercise notes
  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  # whenever a liveview state changes, the render function is automatically
  # called to render a new view with the updated state. LiveView only sends
  # the *changes* to the client over the websocket

end
