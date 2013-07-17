## Asset Host Selection
A basic pattern for ActionController to select between multiple CDNs.

Supports:
* Multiple asset providers
* Disabling asset providers
* CDN killswitch environment variable to disable all CDNs


## Usage

The host application is required to configure the desired asset providers, and handle the selection logic with an object that responds to #select and returns a provider:

```ruby
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
```

## Copyright and license
Copyright 2013 Zendesk
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
