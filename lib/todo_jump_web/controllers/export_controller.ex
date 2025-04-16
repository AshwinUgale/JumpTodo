defmodule TodoJumpWeb.ExportController do
  use TodoJumpWeb, :controller

  def index(conn, _params) do
    tasks = [
      %{title: "Buy milk", due_date: "2024-04-17", completed: false},
      %{title: "Finish app", due_date: "2024-04-16", completed: true}
    ]

    csv = tasks
    |> Enum.map(fn t -> [t.title, t.due_date, t.completed] end)
    |> CSV.encode()
    |> Enum.join("")

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"tasks.csv\"")
    |> send_resp(200, csv)
  end
end
