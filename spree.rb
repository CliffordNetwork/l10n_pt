# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'


require 'spree/product_filters'

Spree.config do |config|
  config.shipping_instructions = true
  config.checkout_zone = 'United Kingdom'
  config.address_requires_state = true
  config.currency = 'GBP'
  country = Spree::Country.find_by_name('United Kingdom')
  config.default_country_id = country.id if country.present?

  # 12 should be Australia. Hardcoded for CI (Jenkins), where countries are not pre-loaded.
  #config.default_country_id = 113

  # -- spree_paypal_express
  # Auto-capture payments. Without this option, payments must be manually captured in the paypal interface.
  config.auto_capture = true
  #config.override_actionmailer_config = false
end


# TODO Work out why this is necessary
# Seems like classes within OFN module become 'uninitialized' when server reloads
# unless the empty module is explicity 'registered' here. Something to do with autoloading?
module OpenFoodNetwork
end

# Add calculators category for enterprise fees
module Spree
  module Core
    class Environment
      class Calculators
        include EnvironmentExtension

        attr_accessor :enterprise_fees
      end
    end
  end
end

# Forcing spree to always allow SSL connections
# Since we are using config.force_ssl = true
# Without this we get a redirect loop: see https://groups.google.com/forum/#!topic/spree-user/NwpqGxJ4klk
SslRequirement.module_eval do
  protected

  def ssl_allowed?
    true
  end
end
