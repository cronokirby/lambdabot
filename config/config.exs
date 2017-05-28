use Mix.Config

day = 1000 * 60 * 60 * 24

config :lambdabot,
  lambda_role: "282086480229171200",
  lambda_channel: "313899553629667328",
  token: "fill this in",
  lambda_timeout: (7 * day)
