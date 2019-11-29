ShopifyApp.configure do |config|
  config.application_name = "Bensearch"
  config.api_key = "f3fc481017cfb0ac799b1b95868efda8"
  config.secret = "ea565f8ab58f7b2925b5d354d33a826a"
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
