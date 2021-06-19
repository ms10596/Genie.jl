@testset "Sessions functionality" begin

  @testset "Simple session setting and getting" begin
    using Genie, Genie.Sessions
    using Genie.Router
    using HTTP

    Genie.config.session_storage = :File
    Sessions.init()

    route("/home") do
      sess = Sessions.session(params())
      Sessions.set!(sess, :visit_count, Sessions.get(sess, :visit_count, 0)+1)

      "$(Sessions.get(sess, :visit_count))"
    end

    Genie.up(; open_browser = false)

    # TODO: extend to use the cookie and increment the count
    response = HTTP.get("http://$(Genie.config.server_host):$(Genie.config.server_port)/home")
    @test response.body |> String == "1"

    Genie.down()
  end;

end;