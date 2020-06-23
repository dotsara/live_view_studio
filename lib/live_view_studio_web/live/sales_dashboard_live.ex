defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    # we want the liveview process to send a message to itself every
    # second to update with assign_stats.
    # but! since mount is invoked twice, we want to wait until there's
    # a connection before we send the message.
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end
    socket = assign_stats(socket)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>
      <button phx-click="refresh">
        <img src="images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  # while user (external) events are handled with handle_event
  # internal messages are handled by handle_info callbacks
  def handle_info(:tick, socket) do
    socket = assign_stats(socket)
    {:noreply, socket}
  end

  # to update the stats we need to update using the same code that
  # we already had in mount. So, instead of repeating, we make a new
  # private function and then call *it* from the other 2 places
  # (mount & refresh handle_event)
  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
