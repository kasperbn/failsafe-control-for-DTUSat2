# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bachelor_session',
  :secret      => '6954eb8d56f9caed4710a503eb56bc3fe9146691174ec724e068499cbd66c16359951937c1a3ef23ec70c6fbf833b8843e12fb20def69fe7e8813def5550eafd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
