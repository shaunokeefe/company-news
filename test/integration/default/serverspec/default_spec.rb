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

  let (:conn) do
    c = Faraday.new(:url => 'http://localhost:8080')
    c
  end

  it 'should have webapp installed' do
    res = conn.get('/sample/')
    expect(res.status).to eq(200)
  end
end
