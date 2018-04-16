# reference: https://medium.brianemory.com/elixir-phoenix-creating-an-app-part-4-using-google-%C3%BCberauth-e7d2ed1a3541
defmodule CcmonitorWeb.AuthController do
  use CcmonitorWeb, :controller
  plug Ueberauth

  alias Ccmonitor.Users
  alias Ccmonitor.Users.User
  alias Ccmonitor.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}
    changeset = User.changeset(%User{}, user_params)

    create(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end

  def create(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: page_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
