use Mix.Config

day = 1000 * 60 * 60 * 24

config :lambdabot,
  lambda_role: "282086480229171200",
  lambda_channel: "313899553629667328",
  token: "token_here",
  lambda_timeout: (7 * day),
  lang_roles: %{
    "Clojure" => "312810342361333761",
    "Elixir" => "287716693315158016",
    "Erlang" => "287716104011251713",
    "Haskell" => "287714669429391360",
    "Idris" => "287716632761991178",
    "Lisp" => "287716659362529280",
    "Racket" => "287715918123892738",
    "Scala" => "312810532577214474",
    "Scheme" => "287716577716207616",
  }
