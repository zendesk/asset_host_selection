# providers = {
#   :cloudfront => {
#     :subdomain => "example",
#     :domain    => "cloudfront.net",
#     :cdn       => true
#   },
#   :edgecast => {
#     :subdomain => "assets",
#     :domain    => example.com,
#     :cdn       => true
#   },
#   :internal => {
#     :subdomain => "assets2",
#     :domain    => example.com,
#     :cdn       => false
#   }
# }
#
#
# provider_pool     = ProviderPool.new(providers)
# config.asset_host = AssetHostSelection::AssetHostname.new(provider_pool)
class ProviderPool

  attr_reader :providers

  def initialize(provider_attributes)
    @providers = AssetHostSelection::AssetProvider.build_all(provider_attributes)
  end

  def select(request)
    account  = request.env["account"]
    provider = account.asset_provider

    if provider.try(:enabled?)
      provider
    else
      providers[:internal]
    end
  end

end
