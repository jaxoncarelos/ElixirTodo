import Config

config :todo, Todo.Repo,
  database: "todo.sqlite3",
  pool_size: 5,
  log: false
config :todo,
  ecto_repos: [Todo.Repo]
