require_relative "helper"

describe AssetHostSelection do

  before do
    @providers = AssetHostSelection::AssetProvider.build_all(
      :cdn   => { :domain => 'example.com', :subdomain => 'cdn',   :enabled => true, :cdn => true  },
      :local => { :domain => 'example.com', :subdomain => 'local', :enabled => true, :cdn => false }
    )
    @cdn   = @providers[:cdn]
    @local = @providers[:local]
  end


  describe "An asset provider" do

    it "has a host" do
      assert_equal "cdn.example.com",   @cdn.host
      assert_equal "local.example.com", @local.host
    end

    describe "#enabled?" do
      after do
        ENV.delete("DISABLE_CDN")
      end

      it "is true by default" do
        provider = AssetHostSelection::AssetProvider.new(:domain => "example.com", :subdomain => "hello")
        assert_equal true, provider.enabled?
      end

      it "is false when disabled" do
        assert @local.enabled?
        @local.enabled = false

        assert_equal false, @local.enabled?
      end

      it "is false for CDNs when disabled in the environment" do
        ENV["DISABLE_CDN"] = "true"
        assert_equal false, @cdn.enabled?
        assert_equal true, @local.enabled?
      end

      it "is true for CDNs when not disabled in the environment" do
        ENV["DISABLE_CDN"] = "somethingelse"
        assert_equal true, @cdn.enabled?
        assert_equal true, @local.enabled?
      end
    end

  end

  describe "An asset host" do
    before do
      @asset_host = AssetHostSelection::AssetHostname.new(TestProviderPool.new(@providers))
    end

    describe "with an SSL request" do
      before do
        @request = cdn_request(:ssl => true, :asset_provider => :cdn)
      end

      it "uses an encrypted asset host" do
        assert_equal "https://cdn.example.com", @asset_host.call("hello.gif", @request)
      end
    end

    describe "with a non-SSL request" do
      before do
        @request = cdn_request(:ssl => false, :asset_provider => :cdn)
      end

      it "uses an unencrypted asset host" do
        assert_equal "http://cdn.example.com", @asset_host.call("hello.gif", @request)
      end
    end

  end

  class TestProviderPool

    attr_reader :providers

    def initialize(providers)
      @providers = providers
    end

    def select(request)
      @providers[request.env["asset_provider"]]
    end

  end

  def cdn_request(args = {})
    host     = args[:host] || "example.com"
    ssl      = args[:ssl]  || false
    provider = args[:asset_provider]

    options = { "HTTP_HOST" => host }
    options["HTTPS"] = "on" if ssl

    env = Rack::MockRequest.env_for("/", options)
    env['asset_provider'] = provider

    Rack::Request.new(env)
  end

end