server '52.36.143.78', user: 'deploy', roles: %w{web app db}


:sidekiq_default_hooks => true
:sidekiq_pid => File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
:sidekiq_env => fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
:sidekiq_log => File.join(shared_path, 'log', 'sidekiq.log')
:sidekiq_options => nil
:sidekiq_require => nil
:sidekiq_tag => nil
:sidekiq_config => nil # if you have a config/sidekiq.yml, do not forget to set this. 
:sidekiq_queue => nil
:sidekiq_timeout => 10
:sidekiq_role => :app
:sidekiq_processes => 1
:sidekiq_options_per_process => nil
:sidekiq_concurrency => nil
:sidekiq_monit_templates_path => 'config/deploy/templates'
:sidekiq_monit_conf_dir => '/etc/monit/conf.d'
:sidekiq_monit_use_sudo => true
:monit_bin => '/usr/bin/monit'
:sidekiq_monit_default_hooks => true
:sidekiq_service_name => "sidekiq_#{fetch(:application)}_#{fetch(:sidekiq_env)}"
:sidekiq_cmd => "#{fetch(:bundle_cmd, "bundle")} exec sidekiq" # Only for capistrano2.5
:sidekiqctl_cmd => "#{fetch(:bundle_cmd, "bundle")} exec sidekiqctl" # Only for capistrano2.5
:sidekiq_user => nil #user to run sidekiq as

set :pty,  false
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.



# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
