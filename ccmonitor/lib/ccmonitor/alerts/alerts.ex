defmodule Ccmonitor.Alerts do
  @moduledoc """
  The Alerts context.
  """

  import Ecto.Query, warn: false
  alias Ccmonitor.Repo

  alias Ccmonitor.Alerts.Alert


  # get all alerts of given user id
  def get_alerts_all(user_id) do
    Repo.all(from a in Alert, where: a.user_id == ^user_id)
  end

  @doc """
  Returns the list of alerts.

  ## Examples

      iex> list_alerts()
      [%Alert{}, ...]

  """
  def list_alerts do
    Repo.all(Alert)
  end

  @doc """
  Gets a single alert.

  Raises `Ecto.NoResultsError` if the Alert does not exist.

  ## Examples

      iex> get_alert!(123)
      %Alert{}

      iex> get_alert!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alert!(id), do: Repo.get!(Alert, id)

  def filter_alerts(base, curr_price, last_price) do
    query = from a in Alert,
                where: (a.coin_type == ^base and a.alert_type == "ASC" and a.threshold < ^curr_price and a.threshold >= ^last_price) or
                       (a.coin_type == ^base and a.alert_type == "DES" and a.threshold > ^curr_price and a.threshold <= ^last_price)
    Repo.all(query)
      |> Enum.map(fn alert -> Repo.preload(alert, :user) end)
    
  end

  @doc """
  Creates a alert.

  ## Examples

      iex> create_alert(%{field: value})
      {:ok, %Alert{}}

      iex> create_alert(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alert(attrs \\ %{}) do
    %Alert{}
    |> Alert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alert.

  ## Examples

      iex> update_alert(alert, %{field: new_value})
      {:ok, %Alert{}}

      iex> update_alert(alert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alert(%Alert{} = alert, attrs) do
    alert
    |> Alert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Alert.

  ## Examples

      iex> delete_alert(alert)
      {:ok, %Alert{}}

      iex> delete_alert(alert)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alert(%Alert{} = alert) do
    Repo.delete(alert)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alert changes.

  ## Examples

      iex> change_alert(alert)
      %Ecto.Changeset{source: %Alert{}}

  """
  def change_alert(%Alert{} = alert) do
    Alert.changeset(alert, %{})
  end
end
