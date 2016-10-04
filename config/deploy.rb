
set :application, 'excel2'
set :repo_url, 'git@github.com:omairrazam/excel2.git'

set :branch, :v2
set :deploy_to, '/home/deploy/excel2'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads }
set :keep_releases, 5
set :rvm_type, :user
#set :rvm_ruby_version, 'jruby-1.7.19' # Edit this if you are using MRI Ruby
set :bundle_binstubs, nil
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false




# namespace :deploy do
#   desc 'Runs rake db:seed for SeedMigrations data'
#   task :seed => [:set_rails_env] do
#     on primary fetch(:migration_role) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, "db:seed"
#         end
#       end
#     end
#   end

#   after 'deploy:migrate', 'deploy:seed'
# end

