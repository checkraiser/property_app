defmodule PropertyApp.Router do
  use PropertyApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PropertyApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    
  end

  scope "/api/v1", PropertyApp do 
    pipe_through :api
    resources "/properties", PropertiesController
  end



  # Other scopes may use custom stacks.
  # scope "/api", PropertyApp do
  #   pipe_through :api
  # end
end
