# encoding: utf-8
# Pa-Toolsmiths

title 'Greenplum-db RPM integration testing'

gpdb_rpm_path = ENV['GPDB_RPM_PATH']
gpdb_rpm_arch = ENV['GPDB_RPM_ARCH']
gpdb_clients_version = ENV['GPDB_CLIENTS_VERSION']
rpm_gpdb_version = ENV['RPM_GPDB_VERSION']
gpdb_version = rpm_gpdb_version.sub("_", "-") if rpm_gpdb_version != nil

control 'Category:server-installs_with_link' do

  impact 1.0
  title 'RPM installs with symbolic link'
  desc 'When the RPM is installed a shorter symbolic link is created and destroyed on uninstall'

  describe file('/usr/local/greenplum-db') do
    it { should be_linked_to "/usr/local/greenplum-db-#{gpdb_version}" }
  end

end

control 'Category:server-greenplum_path.sh' do

  impact 1.0
  title 'greenplum_path.sh is correct'
  desc 'Modification must be made to the given upstream greenplum_path.sh'

  # With default %{prefix}"
  describe command("source /usr/local/greenplum-db-#{gpdb_version}/greenplum_path.sh; echo $GPHOME") do
    its('exit_status') { should eq 0 }
    its('stdout') { should eq "/usr/local/greenplum-db-#{gpdb_version}\n" }
  end

end

control 'Category:server-rpm_binary_match' do

  impact 1.0
  title 'RPM Binary matches Built Source'
  desc 'The binaries that are packaged in the RPM should match in version to what is expected from the source code'

  describe command("source /usr/local/greenplum-db-#{gpdb_version}/greenplum_path.sh ; /usr/local/greenplum-db-#{gpdb_version}/bin/postgres --gp-version") do
    its('exit_status') { should eq 0 }
    skip "its('stdout') { should match /#{gpdb_version}/ }"
  end

end

control 'Category:clients-installs_with_link' do

  impact 1.0
  title 'Package installs with symbolic link'
  desc 'When the package is installed a shorter symbolic link is created and destroyed on uninstall'

  describe file('/usr/local/greenplum-db-clients') do
    it { should be_linked_to "/usr/local/greenplum-db-clients-#{gpdb_clients_version}" }
  end

end

control 'Category:clients-greenplum_clients_path.sh' do

  impact 1.0
  title 'greenplum_clients_path.sh is correct'
  desc 'Modification must be made to the given upstream greenplum_clients_path.sh'

  # With default %{prefix}"
  describe file('/usr/local/greenplum-db-clients/greenplum_clients_path.sh') do
    its('content') { should match /GPHOME_CLIENTS=\/usr\/local\/greenplum-db-clients-#{gpdb_clients_version.split('+').first}/ }
    its('content') { should match /export GPHOME_CLIENTS/ }
  end

  describe command('source /usr/local/greenplum-db-clients/greenplum_clients_path.sh; echo $GPHOME_CLIENTS') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /\/usr\/local\/greenplum-db-clients-#{gpdb_clients_version.split('+').first}/ }
  end

end

control 'Category:ubuntu-clients-greenplum_clients_path.sh' do

  impact 1.0
  title 'greenplum_clients_path.sh is correct'
  desc 'Modification must be made to the given upstream greenplum_clients_path.sh'

  # With default %{prefix}"
  describe file('/usr/local/greenplum-db-clients/greenplum_clients_path.sh') do
    its('content') { should match /GPHOME_CLIENTS=\/usr\/local\/greenplum-db-clients-#{gpdb_clients_version.split('+').first}/ }
    its('content') { should match /export GPHOME_CLIENTS/ }
  end

  describe command('source /usr/local/greenplum-db-clients/greenplum_clients_path.sh; echo $GPHOME_CLIENTS') do
    its('exit_status') { should eq 0 }
  end

end

