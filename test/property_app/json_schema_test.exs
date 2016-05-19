defmodule PropertyApp.JsonSchemaTest do
  use ExUnit.Case, async: true
  alias PropertyApp.JsonSchema
  import PropertyApp.JsonSchemaTestHelper
  

  test "correct params" do
    assert (correct_property_params |> JsonSchema.valid?(:property)) == true
  end

  test "requires bathrooms key " do 
  	assert (requires_key(:bathrooms) |> JsonSchema.valid?(:property)) == false
  end

  test "bathrooms value must be integer and between 0 and 100" do 
    assert (requires_value(:bathrooms, "123") |> JsonSchema.valid?(:property)) == false
  	assert (requires_value(:bathrooms, 101) |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:bathrooms, -1) |> JsonSchema.valid?(:property)) == false
  end
  
  test "requires bedrooms key " do 
    assert (requires_key(:bedrooms) |> JsonSchema.valid?(:property)) == false
  end

  test "bedrooms value must be integer and between 0 and 100" do 
    assert (requires_value(:bedrooms, "abc") |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:bedrooms, 101) |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:bedrooms, -1) |> JsonSchema.valid?(:property)) == false
  end
  
  test "description must be text" do 
    assert (requires_value(:description, 10) |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:description, "") |> JsonSchema.valid?(:property)) == true
  end

  test "serviced must be true or false" do 
    assert (requires_value(:serviced, "true") |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:serviced, "false") |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:serviced, 123) |> JsonSchema.valid?(:property)) == false
  end

  test "requires lat key" do 
    assert (requires_key(:lat) |> JsonSchema.valid?(:property)) == false
  end

  test "lat must be a number" do 
    assert (requires_value(:lat, "test") |> JsonSchema.valid?(:property)) == false
  end

  test "lat is not null" do 
    assert (requires_value(:lat, nil) |> JsonSchema.valid?(:property)) == false
  end

  test "lat must be greater or equal to -90" do 
    assert (requires_value(:lat, -90) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lat, -89) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lat, -91) |> JsonSchema.valid?(:property)) == false
  end

  test "lat must be less than or equal to 90" do 
    assert (requires_value(:lat, 90) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lat, 89) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lat, 91) |> JsonSchema.valid?(:property)) == false
  end

  test "requires lon key" do 
    assert (requires_key(:lon) |> JsonSchema.valid?(:property)) == false
  end
  
  test "lon must be a number" do 
    assert (requires_value(:lon, "test") |> JsonSchema.valid?(:property)) == false
  end

  test "lon is not null" do 
    assert (requires_value(:lon, nil) |> JsonSchema.valid?(:property)) == false
  end

  test "lon must be greater or equal to -180" do 
    assert (requires_value(:lon, -180) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lon, -179) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lon, -181) |> JsonSchema.valid?(:property)) == false
  end

  test "lon must be less than or equal to 180" do 
    assert (requires_value(:lon, 180) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lon, 179) |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:lon, 181) |> JsonSchema.valid?(:property)) == false
  end

  test "requires kind key" do 
    assert (requires_key(:kind) |> JsonSchema.valid?(:property)) == false
  end

  test "kind is not null" do 
    assert (requires_value(:kind, nil) |> JsonSchema.valid?(:property)) == false
  end

  test "kind is string" do 
    assert (requires_value(:kind, 123) |> JsonSchema.valid?(:property)) == false
  end

  test "kind must be in enum" do 
    assert (requires_value(:kind, "room1") |> JsonSchema.valid?(:property)) == false
    assert (requires_value(:kind, "room") |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:kind, "house") |> JsonSchema.valid?(:property)) == true
    assert (requires_value(:kind, "apartment") |> JsonSchema.valid?(:property)) == true
  end
end
