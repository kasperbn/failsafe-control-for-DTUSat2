# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dtusat-gum_session',
  :secret      => 'cda95268abcdc35ffffeb68078fcbc27b2f548cf76f322a1c3033adb1f51a7d73912488a868838751f94d96e27f299e6ed409aa0a171a7d31fba90a89467a9ee'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
