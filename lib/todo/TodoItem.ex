defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :text, :string
    field :done, :boolean, default: false
    timestamps()
  end

  def changeset(item, attrs) do
      item
      |> cast(attrs, [:text, :done])
      |> validate_required([:text])
  end
end
