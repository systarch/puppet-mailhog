require 'spec_helper'

describe 'mailhog' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:params) do {
            mailhog_version: '3.2.1'
        }
        end

        context "mailhog class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('mailhog::params') }
          it { is_expected.to contain_class('mailhog::install').that_comes_before('Class[mailhog::config]') }
          it { is_expected.to contain_class('mailhog::config') }
          it { is_expected.to contain_class('mailhog::service').that_subscribes_to('Class[mailhog::config]') }

          it { is_expected.to contain_exec('Download MailHog 3.2.1') }

          it { is_expected.to contain_file('/etc/mailhog.conf') }
          it { is_expected.to contain_file('/etc/init.d/mailhog') }
          it { is_expected.to contain_file('/var/lib/mailhog') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin/mailhog') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin/mailhog-3.2.1') }

          it { is_expected.to contain_package('curl') }
          it { is_expected.to contain_package('daemon') }

          it { is_expected.to contain_user('mailhog') }

          it { is_expected.to contain_service('mailhog') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'mailhog class without any parameters on Solaris' do
      let(:facts) do
        {
            os: {
                'architecture' => 'x386',
                'family' => 'Solaris',
            }
        }
      end

      it { is_expected.to raise_error(Puppet::Error, /Solaris not supported/) }
    end
  end
end
