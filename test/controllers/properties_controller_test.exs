defmodule PropertyApp.PropertiesControllerTest do
  use PropertyApp.ConnCase
  import PropertyApp.JsonSchemaTestHelper
  alias PropertyApp.PropertyRepo
  @attributes ~W(bathrooms)
  @valid_attrs correct_property_params
  setup %{conn: conn} do
  	PropertyRepo.delete_all && :ok
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
  test "create" do
  	#post conn, properties_path(conn, :create, %{property: correct_property_params} )
  	conn = post conn, properties_path(conn, :create), property: @valid_attrs
  	assert conn.status == 201
  	property = conn.assigns[:property] 
  	assert property[:bathrooms] == @valid_attrs[:bathrooms]
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
