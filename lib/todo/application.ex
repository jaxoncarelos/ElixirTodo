defmodule Todo.Application do
  use Application

  def start(_type, _args) do
    children = [
      Todo.Repo
    ]
    opts = [strategy: :one_for_one, name: Todo.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    Task.start(fn ->
      :timer.sleep(200)
      Todo.run()
    end)

    :timer.sleep(:infinity)


    {:ok, pid}
  end
end
