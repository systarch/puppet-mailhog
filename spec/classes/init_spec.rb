require 'spec_helper'

describe 'mailhog' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:params) do {
            mailhog_version: '3.2.1',
        }
        end

        context "mailhog class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('mailhog::params') }
          it { is_expected.to contain_class('mailhog::install').that_comes_before('Class[mailhog::config]') }
          it { is_expected.to contain_class('mailhog::config') }
          it { is_expected.to contain_class('mailhog::service').that_subscribes_to('Class[mailhog::config]') }

          it { is_expected.to contain_exec('Download MailHog 3.2.1') }

          it { is_expected.to contain_file('/etc/mailhog.conf').with_ensure('file') }
          it { is_expected.to contain_file('/etc/init.d/mailhog').with_ensure('file') }
          it { is_expected.to contain_file('/var/lib/mailhog').with_ensure('directory') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin').with_ensure('directory') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin/mailhog').with_ensure('link') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin/mailhog-3.2.1').with_ensure('file') }

          it { is_expected.to contain_package('curl').with_ensure('installed') }
          it { is_expected.to contain_package('daemon').with_ensure('present') }

          it { is_expected.to contain_user('mailhog').with_ensure('present') }

          it { is_expected.to contain_service('mailhog').with_ensure('running') }
          it { is_expected.to contain_service('mailhog').with_enable(true) }
        end
      end
    end

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        let(:params) do {
            ensure: 'absent',
            mailhog_version: '3.2.1',
        }
        end
        context "mailhog class with ensure=absent" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('mailhog::params') }
          it { is_expected.to contain_class('mailhog::service').that_comes_before('Class[mailhog::install]') }
          it { is_expected.to contain_class('mailhog::install').that_comes_before('Class[mailhog::config]') }
          it { is_expected.to contain_class('mailhog::config') }

          it { is_expected.not_to contain_exec('Download MailHog 3.2.1') }

          it { is_expected.to contain_file('/etc/mailhog.conf').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/init.d/mailhog').with_ensure('absent') }
          it { is_expected.to contain_file('/var/lib/mailhog').with_ensure('absent') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin').with_ensure('absent') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin/mailhog').with_ensure('absent') }
          it { is_expected.to contain_file('/var/lib/mailhog/bin/mailhog-3.2.1').with_ensure('absent') }

          it { is_expected.to contain_package('curl').with_ensure('absent') }
          it { is_expected.to contain_package('daemon').with_ensure('absent') }

          it { is_expected.to contain_user('mailhog').with_ensure('absent') }

          it { is_expected.to contain_service('mailhog').with_ensure('stopped') }
          it { is_expected.to contain_service('mailhog').with_enable(false) }
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
