# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store'

Giftr3::Application.config.session_store :dalli_store, :key => '_giftr3_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Giftr3::Application.config.session_store :active_record_store
