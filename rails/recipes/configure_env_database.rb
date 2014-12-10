require 'cgi'
require 'uri'

node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]
  database_url = node[:deploy][application][:environment_variables]['DATABASE_URL']
  unless database_url.nil?
    Chef::Log.info("Creating config/database.yml for #{rails_env} environment")
    begin
      uri = URI.parse(database_url)
    rescue URI::InvalidURIError
      raise "Invalid DATABASE_URL"
    end

    database = {
      adapter: uri.scheme,
      database: (uri.path || "").split("/")[1],
      username: uri.user,
      password: uri.password,
      host: uri.host,
      port: uri.port
    }
    database[:adapter] = "postgresql" if database[:adapter] == "postgres"

    template "#{deploy[:deploy_to]}/shared/config/database.yml" do
      source "database_from_env.yml.erb"
      cookbook 'rails'
      mode "0660"
      group deploy[:group]
      owner deploy[:user]
      variables(:database => database, :environment => deploy[:rails_env])

      only_if do
        File.directory?("#{deploy[:deploy_to]}/shared/config/")
      end
    end
  end
end