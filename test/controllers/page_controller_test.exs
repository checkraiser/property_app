defmodule PropertyApp.PageControllerTest do
  use PropertyApp.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Properties"
  end
end
