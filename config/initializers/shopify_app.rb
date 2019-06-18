ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "bc52c9a9181d9d40ca7d955dd7296f98"
  config.secret = "270c55b25bf136c50210ddcb4e71ca72"
  config.old_secret = "<old_secret>"
  config.scope = "read_products, write_script_tags" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.scripttags = [
    {event:'onload', src: 'https://s3.amazonaws.com/shopify-app-prod/searching.js'}
  ]
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
