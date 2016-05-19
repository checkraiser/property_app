defmodule PropertyApp.PropertiesControllerTest do
  use PropertyApp.ConnCase
  alias PropertyApp.PropertyRepo
  @valid_attrs %{bathrooms: "50", bedrooms: "50", description: "test description", serviced: "true", lat: "10.1", lon: "100", kind: "room"}
  setup %{conn: conn} do
  	PropertyRepo.delete_all && :ok
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
  test "create" do
  	#post conn, properties_path(conn, :create, %{property: correct_property_params} )
  	conn = post conn, properties_path(conn, :create), property: @valid_attrs
  	assert conn.status == 201
  	property = conn.assigns[:property] 
  	assert property[:bathrooms] |> to_string == @valid_attrs[:bathrooms]
  end
  test "index" do
  	conn = post conn, properties_path(conn, :create), property: @valid_attrs
  	property = conn.assigns[:property] 
  	next_conn = get conn, properties_path(conn, :index)
  	assert next_conn.status == 200
  	properties = next_conn.assigns[:properties]
  	assert Enum.any?(properties, fn(x)-> x[:id] == property[:id] end)
  end
end
