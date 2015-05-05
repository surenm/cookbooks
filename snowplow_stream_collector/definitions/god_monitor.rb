#
# Cookbook Name:: god
# Definition:: god_monitor
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :god_monitor, :deploy_to => nil, :env => {} do                                                                 

  service "god" do
    supports :status => true                                                                             
    action :start                                                                                        
  end

  template "#{params[:deploy_to]}/current/collector/config.hocon" do
    source "config.hocon.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
      :kinesis_stream_name => params[:env]["KINESIS_STREAM_NAME"]
    )
  end                                                                                                     
  
  template "/etc/god/conf.d/#{params[:name]}.god" do                                                      
    source "collector.god.erb"                                                                            
    owner "root"                                                                                          
    group "root"                                                                                          
    mode 0644
    variables(
      :name => params[:name],
      :deploy_to => params[:deploy_to],                                                                 
      :env => params[:env]                                                                              
    )
    notifies :restart, resources(:service => "god")                                                       
  end                                                                                                     
end
