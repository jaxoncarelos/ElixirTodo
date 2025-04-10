defmodule Todo do
  require Todo.SQLiteMacros
  import Todo.SQLiteMacros

  def prompt() do
    response = String.trim(IO.gets("What would you like to do (add, list, complete, delete): "))
    n = String.length(response)

    cond do
      n > 100 or n <= 0 ->
        {:badsize}

      true ->
        parse_response(response)
    end
  end

  def parse_response(response) do
    case String.split(response, " ", parts: 2) do
      ["add", todo] ->
        {:addtodo, todo}

      ["list"] ->
        {:listtodos}

      ["delete", todo] ->
        {:deletetodo, todo}

      ["complete", todo] ->
        {:completetodo, todo}

      _ ->
        {:retry}
    end
  end

  def run do
    loop()
  end

  defp loop do
    case prompt() do
      {:retry} ->
        :ok

      {:badsize} ->
        IO.puts("Invalid input, try again: ")

      {:listtodos} ->
        list("{id}: '{text}' is {done}!")

      {:deletetodo, todo} ->
        delete(todo)

      {:completetodo, todo} ->
        complete(todo)

      {:addtodo, todo} ->
        push(todo)
    end

    loop()
  end
end
