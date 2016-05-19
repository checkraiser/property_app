defmodule PropertyApp.PropertiesController do
  use PropertyApp.Web, :controller
  alias PropertyApp.PropertyRepo
  plug :scrub_params, "property" when action in [:create]

  def index(conn, _params) do
    properties = PropertyRepo.all
    conn
    |> put_status(200)
    |> render("index.json", properties: properties)
  end

  def create(conn, %{"property" => property_params}) do 
  	case PropertyRepo.create(property_params) do 
  	  {:ok, property_id} ->
        conn
        |> put_status(201)
        |> render("show.json", property: PropertyRepo.find(property_id))
      _ ->
      	conn
      	|> put_status(400)
      	|> Poison.encode!(%{error: "error"})
    end
  end
end
