defmodule MyApp.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyApp.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        published: true,
        published_at: ~N[2023-05-22 12:36:00],
        title: "some title",
        views: 42
      })
      |> MyApp.Blog.create_post()

    post
  end
end
