defmodule PropertyApp.PropertyRepoTest do 
  use ExUnit.Case, async: true
  import Tirexs.HTTP
  import PropertyApp.JsonSchemaTestHelper
  alias PropertyApp.PropertyRepo
  setup do
  	delete("property_test") && :ok
  end

  test "doesn't allow create wrong property" do 
  	{result, errors} = PropertyRepo.create requires_value(:bathrooms, "123")
  	errors |> Enum.count |> assert_greater(0)
  	result |> assert_equal(:validate_error)
  end

  test "allows create new property" do 
  	{_, property_id} = PropertyRepo.create correct_property_params
  	property = PropertyRepo.find property_id
  	assert property[:bathrooms] == correct_property_params[:bathrooms]
  end

  test "allows get all properties" do 
  	PropertyRepo.create correct_property_params
  	PropertyRepo.all |> Enum.count |> assert_equal(1)
  end

  test "allows delete all properties" do 
  	PropertyRepo.create correct_property_params
  	PropertyRepo.delete_all
  	PropertyRepo.all |> Enum.count |> assert_equal(0)
  end

  defp assert_equal(real_value, expect_value) do 
  	assert real_value == expect_value
  end

  defp assert_greater(real_value, expect_value) do 
  	assert real_value > expect_value
  end
end