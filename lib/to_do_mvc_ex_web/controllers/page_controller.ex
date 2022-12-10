defmodule ToDoMvcExWeb.PageController do
  use ToDoMvcExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
