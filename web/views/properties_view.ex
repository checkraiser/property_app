defmodule PropertyApp.PropertiesView do 
  use PropertyApp.Web, :view 
  def render("show.json", %{property: property}) do
    %{property: property}
  end

  def render("index.json", %{properties: properties}) do 
  	%{properties: properties}
  end
end