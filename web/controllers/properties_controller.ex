defmodule PropertyApp.PropertiesController do
  use PropertyApp.Web, :controller
  alias PropertyApp.PropertyRepo
  alias PropertyApp.JsonSchema
  plug :scrub_params, "property" when action in [:create]
  def index(conn, _params) do
    properties = PropertyRepo.all
    conn
    |> put_status(200)
    |> render("index.json", properties: properties)
  end

  def create(conn, %{"property" => property_params}) do 
	case (property_params |> convert_params |> PropertyRepo.create) do 
  	  {:ok, property_id} ->
        conn
        |> put_status(201)
        |> render("show.json", property: PropertyRepo.find(property_id))
      {:validate_error, errors} ->
      	conn
      	|> put_status(400)
      	|> json(%{error: errors_to_json(errors)})
      	|> halt
    end
  end

  defp errors_to_json(errors) do
    errors |> Enum.map(fn ({msg, _cols}) -> msg end)
  end

  defp convert_params(property_params) do 
	  property_params
	  	|> convert_bathrooms
	  	|> convert_bedrooms
	  	|> convert_lat
	  	|> convert_lon
	  	|> convert_serviced
	
  end

  defp convert_bathrooms(property_params) do
  	if not(is_blank(property_params["bathrooms"])) and not(property_params["bathrooms"] |> is_integer) do 
	  	case Integer.parse(property_params["bathrooms"]) do 
	  	  {val, _} ->
		  	Map.update!(property_params, "bathrooms", fn(_) -> val  end)
	  	  _ ->
	  	  	property_params
	  	end
	else
		property_params
	end
  end

  defp convert_bedrooms(property_params) do
  	if not(is_blank(property_params["bedrooms"])) and not(property_params["bedrooms"] |> is_integer) do 
	  	case Integer.parse(property_params["bedrooms"]) do 
	  	  {val, _} ->
	  		Map.update!(property_params, "bedrooms", fn(_) -> val end)
	  	  _ ->
	  	  	property_params
	  	end
	else
		property_params
	end
  end

  defp convert_lat(property_params) do
  	if not(is_blank(property_params["lat"])) and not(property_params["lat"] |> is_number) do 
	  	case Float.parse(property_params["lat"]) do
	  	  {val, _} ->
	  		Map.update!(property_params, "lat", fn(_) -> val end)
	  	  _ ->
	  	  	property_params
	  	end
	else
		property_params
	end
  end

  defp convert_lon(property_params) do
  	if not(is_blank(property_params["lon"])) and not(property_params["lon"] |> is_number) do
	  	case Float.parse(property_params["lon"]) do
	  	  {val, _} ->
	  		Map.update!(property_params, "lon", fn(_) -> val end)
		  _ ->
		  	property_params
		end
	else
		property_params
	end
  end
  defp convert_serviced(property_params) do 
	Map.update!(property_params, "serviced", fn(val) -> string_to_boolean(val) end)
  end
  defp string_to_boolean(str) do 
  	if str == "true", do: true, else: false
  end

  defp is_blank(str) do 
  	if str do 
  		String.strip(str) == ""
  	else
  		true
  	end
  end
end
