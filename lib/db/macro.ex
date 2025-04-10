defmodule Todo.SQLiteMacros do
  defmacro __using__(_opts) do
    quote do
      import SQLiteMacros
    end
  end

  defmacro list(format_string) do
    quote do
      items = Todo.Repo.all(Todo.Item)

      Enum.each(items, fn item ->
        line =
          unquote(format_string)
          |> String.replace("{id}", to_string(item.id))
          |> String.replace("{text}", to_string(item.text))
          |> String.replace("{done}", Todo.SQLiteMacros.prettify(item.done))

        IO.puts(line)
      end)
    end
  end

  defmacro push(todo) do
    quote do
      changeset = Todo.Item.changeset(%Todo.Item{}, %{text: unquote(todo)})

      case Todo.Repo.insert(changeset) do
        {:error, changeset} -> IO.inspect(changeset.errors, label: "❌ Error")
        _ -> IO.puts("Todo added: \'#{unquote(todo)}\'!")
      end
    end
  end

  defmacro complete(todo) do
    quote do
      case unquote(todo) =~ ~r/^\d+$/ do
        false ->
          case Todo.Repo.get_by(Todo.Item, text: unquote(todo)) do
            nil ->
              IO.puts("❌ Todo not found: #{unquote(todo)}")

            item ->
              Todo.SQLiteMacros.mark_done(item)
          end

        true ->
          case Todo.Repo.get(Todo.Item, String.to_integer(unquote(todo))) do
            nil ->
              IO.puts("❌ Todo not found: #{unquote(todo)}")

            item ->
              Todo.SQLiteMacros.mark_done(item)
          end
      end
    end
  end

  defmacro delete(todo) do
    quote do
      case unquote(todo) =~ ~r/^\d+$/ do
        false ->
          case Todo.Repo.get_by(Todo.Item, text: unquote(todo)) do
            nil ->
              IO.puts("❌ Todo not found: #{unquote(todo)}")

            item ->
              case Todo.Repo.delete(item) do
                {:ok, _} -> IO.puts("Deleted todo! 🗑️")
                {:error, changeset} -> IO.inspect(changeset.errors, label: "Big boy error")
              end
          end

        true ->
          case Todo.Repo.get(Todo.Item, String.to_integer(unquote(todo))) do
            nil ->
              IO.puts("❌ Todo not found: #{unquote(todo)}")

            item ->
              case Todo.Repo.delete(item) do
                {:ok, _} -> IO.puts("Deleted todo! 🗑️")
                {:error, changeset} -> IO.inspect(changeset.errors, label: "Big boy error")
              end
          end
      end
    end
  end
  def prettify(bool) do
    case bool do
      true -> "✅"
      false -> "❌"
    end
  end
  def mark_done(item) do
    changeset = Todo.Item.changeset(item, %{done: true})

    case Todo.Repo.update(changeset) do
      {:ok, _} -> IO.puts("✅ Marked '#{item.text}' as done by ID")
      {:error, _} -> IO.puts("❌ Failed to update")
    end
  end
end
