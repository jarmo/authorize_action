require "spec_helper"

describe AuthorizeAction::Sinatra do
  let(:authorizator) { Class.new { include AuthorizeAction::Sinatra }.new }

  it "#authorize_action! delegates to AuthorizeAction#authorize_action!" do
    expect_any_instance_of(AuthorizeAction).to receive(:authorize_action!)

    authorizator.authorize_action!
  end

  it "#forbid_action! calls Sintra's #halt(403)" do
    expect(authorizator).to receive(:halt).with(403).and_return(:forbidden_result)

    expect(authorizator.send(:forbid_action!)).to eq(:forbidden_result)
  end

  it "#current_action_name finds Sinatra's action name from request" do
    request = double("request", request_method: "GET", path_info: "/foo/bar")
    allow(authorizator).to receive(:request).and_return(request)
    expect(authorizator).to receive(:action).and_return("action-name".to_sym)

    expect(authorizator.send(:current_action_name)).to eq("action-name".to_sym)
  end

  context "#action" do
    it "returns request path when no Sinatra route found" do
      route_handler = -> {}
      route_handler.instance_variable_set(:@route_name, "GET /foo/:bar")
      routes = {
        "GET" => [
          # /foo/:bar
          [/\A\/foo\/([^\/?#]+)\z/, ["bar"], [], route_handler]
        ]
      }
      expect(authorizator.class).to receive(:routes).and_return(routes)

      expect(authorizator.action(:get, "/bar/baz")).to eq("GET /bar/baz".to_sym)
    end

    it "returns request path when Sinatra route found, but no route name exists" do
      route_handler = -> {}
      route_handler.instance_variable_set(:@route_name, nil)
      routes = {
        "GET" => [
          # /foo/:bar
          [/\A\/foo\/([^\/?#]+)\z/, ["bar"], [], route_handler]
        ]
      }
      expect(authorizator.class).to receive(:routes).and_return(routes)

      expect(authorizator.action(:get, "/foo/baz")).to eq("GET /foo/baz".to_sym)
    end

    it "returns Sinatra's GET method route name" do
      route_handler1 = -> {}
      route_handler1.instance_variable_set(:@route_name, "GET /bar/:baz")
      route_handler2 = -> {}
      route_handler2.instance_variable_set(:@route_name, "GET /foo/:bar")
      routes = {
        "GET" => [
          # /bar/:baz
          [/\A\/bar\/([^\/?#]+)\z/, ["baz"], [], route_handler1],
          # /foo/:bar
          [/\A\/foo\/([^\/?#]+)\z/, ["bar"], [], route_handler2]
        ]
      }
      expect(authorizator.class).to receive(:routes).and_return(routes)

      expect(authorizator.action(:get, "/foo/baz")).to eq("GET /foo/:bar".to_sym)
    end

    it "returns Sinatra's POST method route name" do
      route_handler1 = -> {}
      route_handler1.instance_variable_set(:@route_name, "POST /bar/:baz")
      route_handler2 = -> {}
      route_handler2.instance_variable_set(:@route_name, "POST /foo/:bar")
      routes = {
        "POST" => [
          # /bar/:baz
          [/\A\/bar\/([^\/?#]+)\z/, ["baz"], [], route_handler1],
          # /foo/:bar
          [/\A\/foo\/([^\/?#]+)\z/, ["bar"], [], route_handler2]
        ]
      }
      expect(authorizator.class).to receive(:routes).and_return(routes)

      expect(authorizator.action(:post, "/foo/baz")).to eq("POST /foo/:bar".to_sym)
    end
  end

end
