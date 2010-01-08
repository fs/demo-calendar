set :rails_env, 'staging'

role :web, "web2calendar.flatsourcing.com"
role :app, "web2calendar.flatsourcing.com"
role :db, "web2calendar.flatsourcing.com"
set :user, "admin"
set :port, 22222
set :use_sudo, false
set :app_dir, "/var/www/rails/#{application}/#{rails_env}"
set :deploy_to, "/var/www/rails/#{application}/#{rails_env}"
set :branch, "master"

after "deploy:update" do
  run "rm -rf #{current_path}/pids && ln -sf #{app_dir}/shared/pids #{current_path}/"
  run "rm -rf #{current_path}/tmp && ln -sf #{app_dir}/shared/tmp #{current_path}/"
  run "cd #{current_path} && rake db:migrate RAILS_ENV=staging"
end
namespace :deploy do 
  desc "Restarting mod_rails with restart.txt" 
  task :restart, :roles => :app, :except => { :no_release => true } do 
    run "sudo /etc/init.d/httpd restart" 
  end 
end
