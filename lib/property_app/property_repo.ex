defmodule PropertyApp.PropertyRepo do 
  import Tirexs.HTTP
  alias PropertyApp.JsonSchema
  def create(property_attributes, env \\ Mix.env) do
  	case JsonSchema.validate(property_attributes, :property) do 
  	  [] ->
  	  	create_property(property_attributes, env)
  	  errors ->
  	  	{:validate_error, errors}
  	end
  end

  def find(property_id, env \\ Mix.env) do 
  	get("/property_#{env}/properties/#{property_id}") |> transform_elastic_data
  end

  def all(limit \\ 50, env \\ Mix.env) do 
  	post("/property_#{env}/_refresh")
  	get("/property_#{env}/properties/_search?limit=#{limit}&q=*:*") |> transform_properties
  end

  def delete_all(env \\ Mix.env) do
  	post("/property_#{env}/_refresh")
  	delete "/property_#{env}/properties/_query?q=*:*"
  end

  def delete_index(index_name) do 
  	delete("/property_#{index_name}")
  end

  def refresh(env \\ Mix.env) do 
  	post("/property_#{env}/_refresh")
  end
  #==============

  
  defp create_property(property_attributes, env \\ Mix.env) do 
  	result = post "/property_#{env}/properties", property_attributes
  	case result do 
  	  {:ok, 201, return_value}->
  	  	{:ok, return_value[:_id]}
  	  _ ->
  	  	{:server_error}
  	end
  end
  defp transform_elastic_data(elastic_data) do 
  	{_, _, data} = elastic_data
  	transform_property(data)
  end
  defp transform_property(property_data) do 
  	%{} |> Map.merge(%{id: property_data[:_id]}) |> Map.merge(property_data[:_source])
  end
  defp transform_properties(elastic_data) do 
  	case elastic_data do 
  	  {_, _, %{hits: %{hits: result}} } ->
  		result |> transform_keys
  	  _ ->
  	  	[]
  	end
  end

  defp transform_keys(properties) do 
  	Enum.map(properties, fn(property)-> property |> transform_property end)
  end


end