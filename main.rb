require 'json'
require 'mail'
require 'yaml'

old_ip = ''

yaml = YAML.load_file('conf.yml')

File.open("old.json") do |file|
  js = JSON.load(file)
  old_ip = js['ip']
end

File.open("now.json") do |file|
  js = JSON.load(file)

  exit 0 if js['ip'] == old_ip

  mail_from   = yaml['from']
  mail_passwd = yaml['pass']
  mail_to     = yaml['to']
  mail_subject= js['ip']
  mail_body   = 'old : ' + old_ip + ' new : ' + js['ip']

  Mail.defaults do
    delivery_method :smtp, {
      :address => 'smtp.gmail.com',
      :port => 587,
      :domain => 'example.com',
      :user_name => "#{mail_from}",
      :password => "#{mail_passwd}",
      :authentication => :login,
      :enable_starttls_auto => true
    }
  end

  m = Mail.new do
    from "#{mail_from}"
    to "#{mail_to}"
    subject "#{mail_subject}"
    body "#{mail_body}"
  end

  m.charset = "UTF-8"
  m.content_transfer_encoding = "8bit"
  m.deliver
end
