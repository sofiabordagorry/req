defmodule Req.ResponseTest do
  use Req.Case, async: true
  doctest Req.Response, except: [get_header: 2, delete_header: 2]

  test "update_header/4" do
    resp = Req.Response.new(headers: %{"vary" => ["accept"]})

    assert resp
           |> Req.Response.update_header("Vary", "origin", &(&1 ++ ["origin"]))
           |> Req.Response.get_header("vary") == ["accept", "origin"]

    assert resp
           |> Req.Response.update_header("cache-control", "no-cache", fn _ -> flunk() end)
           |> Req.Response.get_header("cache-control") == ["no-cache"]
  end

  test "update_header!/3" do
    resp = Req.Response.new(headers: %{"vary" => ["accept"]})

    assert resp
           |> Req.Response.update_header!("vary", fn _ -> "origin" end)
           |> Req.Response.get_header("vary") == ["origin"]

    assert_raise KeyError, fn ->
      Req.Response.update_header!(resp, "cache-control", & &1)
    end
  end
end
