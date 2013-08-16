Facter.add(:em1_static) do
  confine :kernel => :linux
  setcode do
    ip = nil
    output = %x{grep IPADDR /etc/sysconfig/network-scripts/ifcfg-em1 | cut -d = -f 2}
    output.each { |str|
        tmp = str.chomp
        unless tmp =~ /^127\./
          ip = tmp
          break
        end
    }

    ip
  end
end
