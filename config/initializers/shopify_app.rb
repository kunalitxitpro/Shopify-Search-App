ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "9232eaf6d82d04d6fa3134cdb5710b07"
  config.secret = "7433238c4592202e0feca9f92b48cc0b"
  config.old_secret = "<old_secret>"
  config.scope = "read_products" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
