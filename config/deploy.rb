# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

set :application, 'qna'
set :repo_url, 'https://github.com/Andex/QnA.git'
set :rvm_ruby_version, '2.7.2@qna'

# For sidekiq
set :pty, false

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

# Deletion of old releases
set :keep_releases, 5