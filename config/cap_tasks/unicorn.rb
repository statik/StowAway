set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
set_default(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
set_default(:unicorn_workers) { 2 }
set_default(:unicorn_timeout) { 15 }

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    with_sudo_user do
      sudo "mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}_#{stage}"
      sudo "update-rc.d -f unicorn_#{application}_#{stage} defaults"
    end 
  end
  after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      with_sudo_user do
        sudo "service unicorn_#{application}_#{stage} #{command}"
      end
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
