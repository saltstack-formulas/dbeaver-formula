# frozen_string_literal: true

title 'dbeaver archives profile'

control 'dbeaver source archive' do
  impact 1.0
  title 'should be installed'

  describe file('/opt/local/bin/dbeaver') do
    it { should exist }
  end
end
