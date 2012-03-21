# cap deploy:setup

require 'capistrano/ext/multistage'
require "rvm/capistrano"                                # Load RVM's capistrano plugin.

set :stages, %w(beaglebone staging)
set :default_stage, "beaglebone"
set :rvm_ruby_string, '1.9.2-p290@sample_blog'               # Or whatever env you want it to run in.

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'root')

set :rvm_bin_path, "$HOME/.rvm/bin"
set :rvm_type, :user

puts "ENV['rvm_path']"
puts "rvm_path => #{ENV['rvm_path']}"
puts "END ENV['rvm_path']"

pute "ENV['PADRINO_ENV'] ="
puts ENV['PADRINO_ENV']

namespace :deploy do

  desc "Restarting mod_rails with restart.txt, capistrano runs this by default"
  task :restart, :roles => :app, :except => { :no_release => true } do
    puts "************ running => task :restart, :roles => :app, :except => { :no_release => true }"
    run "touch #{current_path}/tmp/restart.txt"
  end

  # NOTE: you must manually create the "#{shared_path}/config/" dir since capistrano does not create a "config" dir for you
  # unless you already ran "cap deploy:setup" which would have created the dir and put the database.yml into it
  
  desc 'moves the current .rvmrc into #{shared_path/config/.rvmrc and symlinks it'
  namespace :rvmrc do
    task :symlink, :except => { :no_release => true } do
      puts "************ running: deploy.rb: symlinking .rvmrc: ln -nfs #{shared_path}/config/.rvmrc #{release_path}/config/.rvmrc"
      run "mv -vf #{release_path}/.rvmrc #{shared_path}/config/.rvmrc"
      puts "************ running: ln -nfs #{shared_path}/config/.rvmrc #{release_path}/.rvmrc"
      # run "ln -nfs .rvmrc #{shared_path}/config/.rvmrc"
      run "ln -nfs #{shared_path}/config/.rvmrc #{release_path}/.rvmrc"
    end
  end
  
  
end # namespace :deploy do

after "deploy:symlink",       "deploy:rvmrc:symlink"

=begin
can ssh to the box and run:

  bundle exec padrino rake ar:create -e beaglebone
  bundle exec padrino rake ar:migrate -e beaglebone
  bundle exec padrino rake seed -e beaglebone
  bundle exec padrino start -e beaglebone

  bundle exec padrino rake ar:migrate -e production 
once you are deployed
=end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end