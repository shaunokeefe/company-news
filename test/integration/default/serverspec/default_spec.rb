require 'spec_helper'

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
end
