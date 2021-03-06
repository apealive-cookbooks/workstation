

case node['platform_family']
when 'debian'

  # dist = `eval $(cat /etc/lsb-release); echo $DISTRIB_CODENAME`
  dist = node.attribute?('lsb') ? node['lsb']['codename'] : 'notlinux'
  packages = []

  case node['pantry-workstation']['external-packages']
  when 'authoring'
    apt_repository do
      uri 'ppa:neovim-ppa/unstable'
      distribution dist
      action :add
    end
    _packages.append('neovim')

  when 'saltstack'
    apt_repository do
      uri 'http://repo.saltstack.com/apt/debian/8/amd64/latest'
      key 'https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub'
      distribution dist
      action :add
    end
    _packages.append %w(
      #salt-master
      #salt-minion
      salt-ssh
      salt-cloud
    )
  end

when 'rhel'
  # tbd

end

# merge configuration
node.set['packages-cookbook'] = [node['packages-cookbook'], packages].flatten
include_recipe 'packages'
