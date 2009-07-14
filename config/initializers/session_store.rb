# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cuan_session',
  :secret      => '7b2c3544cfd2390a96980fd5b25b638148e4ec548c2877e49448935be42318eb7085f32fe580c772b6cd378a0aa4a15109ed28edb1d3a34b989586fdf0491735'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
