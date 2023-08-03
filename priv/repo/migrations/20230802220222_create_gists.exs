defmodule ElixirGist.Repo.Migrations.CreateGists do
  use Ecto.Migration

  def change do
    create table(:gists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :markup_text, :text
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:gists, [:user_id])
  end
end
