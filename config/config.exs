import Config

config :todo_jump, ecto_repos: []

config :todo_jump, TodoJumpWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TodoJumpWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TodoJump.PubSub,
  live_view: [signing_salt: "secret"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{config_env()}.exs"
