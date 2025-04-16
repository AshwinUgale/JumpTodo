defmodule TodoJumpWeb.TodoLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, tasks: [], title: "", due_date: "", sort_by: :due_date)}
  end

  def handle_event("add", %{"title" => title, "due_date" => due_date}, socket) do
    task = %{
      id: System.unique_integer([:positive]),
      title: title,
      due_date: due_date,
      completed: false
    }

    {:noreply, update(socket, :tasks, fn tasks -> [task | tasks] end)}
  end

  def handle_event("toggle", %{"id" => id}, socket) do
    id = String.to_integer(id)
    tasks = Enum.map(socket.assigns.tasks, fn task ->
      if task.id == id, do: %{task | completed: !task.completed}, else: task
    end)

    {:noreply, assign(socket, tasks: tasks)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    id = String.to_integer(id)
    tasks = Enum.reject(socket.assigns.tasks, fn task -> task.id == id end)

    {:noreply, assign(socket, tasks: tasks)}
  end

  def handle_event("sort", %{"by" => by}, socket) do
    key = String.to_atom(by)
    tasks = Enum.sort_by(socket.assigns.tasks, &Map.get(&1, key))
    {:noreply, assign(socket, tasks: tasks, sort_by: key)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-xl mx-auto">
      <h1 class="text-2xl font-bold mb-4">To-Do List</h1>

      <form phx-submit="add" class="space-y-2">
        <input name="title" value={@title} placeholder="Task title" class="border px-2 py-1" required/>
        <input type="date" name="due_date" value={@due_date} class="border px-2 py-1" required/>
        <button class="bg-blue-500 text-white px-4 py-1 rounded">Add Task</button>
      </form>

      <div class="mt-4">
        <button phx-click="sort" phx-value-by="due_date" class="text-sm underline">Sort by Due Date</button>
        <button phx-click="sort" phx-value-by="completed" class="text-sm underline ml-2">Sort by Completed</button>
        <a href="/export" class="ml-4 text-sm underline">Export CSV</a>
      </div>

      <ul class="mt-4 space-y-2">
        <%= for task <- @tasks do %>
          <li class="flex justify-between items-center border p-2">
            <div>
              <span class={if task.completed, do: "line-through"}><%= task.title %></span>
              <span class="text-xs text-gray-500">(Due: <%= task.due_date %>)</span>
            </div>
            <div class="space-x-2">
              <button phx-click="toggle" phx-value-id={task.id} class="text-green-600 text-sm">✔️</button>
              <button phx-click="delete" phx-value-id={task.id} class="text-red-600 text-sm">🗑️</button>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
