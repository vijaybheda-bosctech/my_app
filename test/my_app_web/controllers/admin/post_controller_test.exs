defmodule MyAppWeb.Admin.PostControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.Blog

  @create_attrs %{body: "some body", published: true, published_at: ~N[2023-05-22 12:39:00], title: "some title", views: 42}
  @update_attrs %{body: "some updated body", published: false, published_at: ~N[2023-05-23 12:39:00], title: "some updated title", views: 43}
  @invalid_attrs %{body: nil, published: nil, published_at: nil, title: nil, views: nil}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, ~p"/admin/posts"
      assert html_response(conn, 200) =~ "Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get conn, ~p"/admin/posts/new"
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, ~p"/admin/posts", post: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == "/admin/posts/#{id}"

      conn = get conn, ~p"/admin/posts/#{id}"
      assert html_response(conn, 200) =~ "Post Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, ~p"/admin/posts", post: @invalid_attrs
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get conn, ~p"/admin/posts/#{post}/edit"
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put conn, ~p"/admin/posts/#{post}", post: @update_attrs
      assert redirected_to(conn) == ~p"/admin/posts/#{post}"

      conn = get conn, ~p"/admin/posts/#{post}" 
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, ~p"/admin/posts/#{post}", post: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete conn, ~p"/admin/posts/#{post}"
      assert redirected_to(conn) == "/admin/posts"
      assert_error_sent 404, fn ->
        get conn, ~p"/admin/posts/#{post}"
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
