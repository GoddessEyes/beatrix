defmodule BeatrixWeb.Router do
  use BeatrixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BeatrixWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
