defmodule ToDoMvcExWeb.TodoLive do
  use ToDoMvcExWeb, :live_view

  def mount(_params, _session, socket) do
    todos = [
      %{id: Ecto.UUID.generate(), title: "Learn LiveView", completed?: false},
      %{id: Ecto.UUID.generate(), title: "Build a cool app", completed?: false},
      %{id: Ecto.UUID.generate(), title: "Ship it!", completed?: true}
    ]

    socket =
      socket
      |> assign(:filter, "all")
      |> assign(:todos, todos)
      |> assign(:filtered_todos, todos)
      |> update_has_completed()
      |> count_active()

    {:ok, socket}
  end

  def handle_event("change_filter", %{"filter" => filter}, socket) do
    socket =
      socket
      |> assign(:filter, filter)
      |> filter_todos()

    {:noreply, socket}
  end

  def handle_event("todo_form_submit", %{"new_todo" => %{"message" => title}}, socket) do
    new_todo = %{id: Ecto.UUID.generate(), title: title, completed?: false}

    socket =
      socket
      |> assign(:todos, [new_todo] ++ socket.assigns.todos)
      |> filter_todos()
      |> update_has_completed()

    {:noreply, socket}
  end

  def handle_event("clear_completed", _params, socket) do
    socket =
      socket
      |> assign(
        :todos,
        Enum.filter(socket.assigns.todos, fn todo ->
          not todo.completed?
        end)
      )
      |> filter_todos()
      |> assign(:has_completed?, false)

    {:noreply, socket}
  end

  def handle_event("toggle_todo_completed", %{"id" => id}, socket) do
    socket =
      socket
      |> assign(
        :todos,
        for todo <- socket.assigns.todos do
          if todo.id == id do
            %{todo | completed?: not todo.completed?}
          else
            todo
          end
        end
      )
      |> filter_todos()

    {:noreply, socket}
  end

  def filter_button(assigns) do
    ~H"""
    <button phx-click="change_filter"
      phx-value-filter={@filter}
      style={if @current_filter == @filter, do: "background-color: red", else: ""}
    >
      <%= @label %>
    </button>
    """
  end

  defp filter_todos(socket) do
    socket
    |> assign(
      :filtered_todos,
      Enum.filter(socket.assigns.todos, fn todo ->
        case socket.assigns.filter do
          "all" -> true
          "active" -> not todo.completed?
          "completed" -> todo.completed?
        end
      end)
    )
  end

  defp update_has_completed(socket) do
    socket
    |> assign(
      :has_completed?,
      Enum.any?(socket.assigns.todos, fn todo ->
        todo.completed?
      end)
    )
  end

  defp count_active(socket) do
    socket
    |> assign(
      :active_count,
      Enum.count(
        socket.assigns.todos,
        fn todo -> not todo.completed? end
      )
    )
  end
end
