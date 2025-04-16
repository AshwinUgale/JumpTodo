import Config

config :todo_jump, TodoJumpWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  url: [host: System.get_env("RENDER_EXTERNAL_HOSTNAME") || "localhost", port: 80],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
