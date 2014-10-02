module AssetHostSelection

  class AssetProvider

    attr_accessor :enabled, :cdn

    def self.build_all(attributes = {})
      providers = {}
      settings_to_provider = {}
      settings_to_provider.compare_by_identity
      attributes.each do |key, settings|
        providers[key.to_sym] = settings_to_provider.fetch(settings) do
          settings_to_provider[settings] = new(settings)
        end
      end

      providers
    end

    def initialize(options = {})
      @domain    = options.fetch(:domain)
      @subdomain = options.fetch(:subdomain)
      @enabled   = options[:enabled]
      @cdn       = options[:cdn]
    end

    def host
      @host ||= [ @subdomain, @domain ].join(".")
    end

    def enabled?
      return false if @cdn && cdn_disabled?
      @enabled != false
    end

    protected

    def cdn_disabled?
      ENV['DISABLE_CDN'] =~ /yes|true/
    end

  end

  class AssetHostname

    def initialize(selector)
      @selector = selector
    end

    def call(source, request = nil)
      return nil if !request

      asset_provider = @selector.select(request)
      host           = asset_provider.host if asset_provider

      if host.nil?
        # Relative URL. Useful in dev where no CDNs are configured
        nil
      else
        "http#{"s" if request.ssl?}://#{host}"
      end
    end

  end
end
