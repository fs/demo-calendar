# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_web_2_0_events_session',
  :secret      => 'dba2d64b028b1e7e20de3e578434db2de094af79ad04a3bc2f8531f10fa083dcf4281979c1a59dbc89816ca7e96927e8e0c42389894dec408c34086009a1c09f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
