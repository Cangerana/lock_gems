
def find(file, partten, arr=[])
  if arr.empty?
    file.scan(partten)
  else
    arr.map do | gem |
      file.match eval(partten)
    end
  end

end


def main
  path = ARGV[0]
  gemfile = path
  gemlock = "#{path}.lock"

  gem_stream = File.open(gemfile)
  gemfile = gem_stream.read

  # gemfile = gemfile.gsub('"', "'")

  gems = find(gemfile, /(?<=gem ['"])\S+(?=["']\s*$)/)

  lock_stream = File.open(gemlock)
  lockfile = lock_stream.read

  locks = find(lockfile, '/(?<gem>\b#{gem}\b) \(=* *(?<version>\d.*)\)/', gems)

  puts locks

  locks.map do | lgem |
    unless lgem.nil?
      gemfile = gemfile.gsub(/(?<=gem ['"]#{lgem[:gem]})['"]$/, '\0, ' + "'#{lgem[:version]}'")
    end
  end

  File.write(path, gemfile)
end

main
