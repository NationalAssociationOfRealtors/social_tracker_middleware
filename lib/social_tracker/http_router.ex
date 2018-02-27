defmodule SocialTracker.HTTPRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    template_dir = :code.priv_dir(:social_tracker)
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, "#{template_dir}/tweets.html.eex")
  end

end
