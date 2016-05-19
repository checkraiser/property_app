defmodule PropertyApp.JsonSchemaTestHelper do 
  
  def correct_property_params do 
  	%{bathrooms: 50, bedrooms: 50, description: "test description", serviced: true, lat: 10.1, lon: 100, kind: "room"}
  end

  def requires_key(key) do 
  	correct_property_params |> Map.delete(key)
  end

  def requires_value(key, value) do 
  	correct_property_params |> Map.put(key, value)
  end
end

