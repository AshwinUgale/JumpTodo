defmodule TodoJumpWeb.Router do
  use TodoJumpWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoJumpWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", TodoJumpWeb do
    pipe_through :browser

    live "/", TodoLive
    get "/export", ExportController, :index
  end
end
