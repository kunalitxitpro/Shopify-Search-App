ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "5573586911fcbdb0753ba3083757f055"
  config.secret = "2836200d3b9f7b581778296ac86fc318"
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
