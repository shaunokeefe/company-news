require 'spec_helper'
#https://github.com/test-kitchen/busser-serverspec#-usage
require 'faraday'

describe 'company-news::default' do
  describe 'should have java installed' do
    describe package('openjdk-7-jdk') do
      it { should be_installed.by('apt') }
    end

    describe command('java -version 2>&1') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/java version "1\.7/) }
    end
  end

  describe 'should have tomcat installed' do
    describe package('tomcat7') do
      it { should be_installed.by('apt') }
    end
  end

  describe 'should have tomcat service running' do
    describe service('tomcat7') do
      it { should be_running }
    end
  end

  describe 'should have tomcat user and group' do
    describe group('tomcat7') do
      it { should exist }
    end

    describe user('tomcat7') do
      it { should exist }
      it { should belong_to_group 'tomcat7' }
      it { should have_home_directory '/usr/share/tomcat7' }
    end
  end

  describe 'should have tomcat listening on port 8080' do
    describe port(8080) do
        it { should be_listening.with('tcp') }
    end
  end

  describe 'should not be listening on 8443' do
    describe port(8443) do
        it { should_not be_listening.with('tcp') }
    end
  end

  describe 'should have webapp installed' do
    let (:conn) do
      c = Faraday.new(:url => 'http://localhost:8080')
      c
    end
    it 'returns the sample page' do
      res = conn.get('/sample/')
      expect(res.status).to eq(200)
    end
  end

  describe 'nginx' do
    let (:conn_ssl) do
      c = Faraday.new(:url => 'https://localhost', :ssl => {:verify => false})
      c
    end

    describe file('/etc/nginx/ssl/companynews.com/server.crt') do
      it { should be_file }
    end

    describe file('/etc/nginx/ssl/companynews.com/server.key') do
      it { should be_file }
    end

    describe port(80) do
      it { should be_listening.with('tcp') }
    end

    describe port(443) do
      it { should be_listening.with('tcp') }
    end

    describe file('/etc/nginx/sites-available/company_news') do
      it { should be_file }
      # proxy to the load balancing group
      its(:content) { should match(/^[^#]*upstream app {\n\s*server localhost:8080;/) }
      its(:content) { should match(/^[^#]*proxy_pass http:\/\/app;/) }
      # set header to point to original host
      its(:content) { should match(/^[^#]*proxy_set_header Host \$host;/) }
      # pass IP of client to proxied server
      its(:content) { should match(/^[^#]*proxy_set_header X-Real-IP \$remote_addr;/) }
      # give the proxied server a list of all servers that we've been proxied through
      its(:content) { should match(/^[^#]*proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;/) }
      # tell the proxied server whether the original request was http/https
      its(:content) { should match(/^[^#]*proxy_set_header X-Forwarded-Proto \$scheme;/) }
    end

    it 'should be serving the sample page over https' do
      res = conn_ssl.get('/sample/')
      expect(res.status).to eq(200)
    end
  end
end
