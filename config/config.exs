use Mix.Config

day = 1000 * 60 * 60 * 24

config :lambdabot,
  lambda_role: "282086480229171200",
  lambda_channel: "313899553629667328",
  token: "token_here",
  lambda_timeout: (7 * day),
  lang_roles: %{
    "clojure" => "312810342361333761",
    "elixir" => "287716693315158016",
    "erlang" => "287716104011251713",
    "haskell" => "287714669429391360",
    "idris" => "287716632761991178",
    "lisp" => "287716659362529280",
    "racket" => "287715918123892738",
    "scala" => "312810532577214474",
    "scheme" => "287716577716207616",
  }
