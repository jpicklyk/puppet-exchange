if Facter.value(:hostname) =~ /^ex((?:cas|a|u|mb))[0-9]*\-([a-z0-9]+)$/i
  if $1.downcase == "a" or $1.downcase == "u"
    Facter.add('exchange_role') do
      setcode do
        if $1.downcase == "a" or $1.downcase == "u"
          "unified"
        elsif $1.downcase == "mb"
          "mailbox"
        else
          $1
        end
      end
    end
  end
end
