def find(file, partten, arr=[])
  if arr.empty?
    file.scan(partten)
  else
    arr.map do | gem |
      file.match eval(partten)
    end
  end
end

def access_file(path, text='')
  response = false
  begin
    unless text.length > 0
      file = File.open(path)
      response = file.read
    else
      response = File.write(path, text)
    end
  rescue
    puts "Falha ao acessar path: #{path}"
    exit
  ensure
    file.close if file
    puts
  end

  return response
end

def main
  path = ARGV[0]

  gemfile = path
  gemlock = "#{path}.lock"

  gemfile = access_file(gemfile)

  gems = find(gemfile, /(?<=gem ['"])\S+(?=["']\s*$)/)
  
  lockfile = access_file(gemlock)

  locks = find(lockfile, '/(?<gem>\b#{gem}\b) \(=* *(?<version>\d.*)\)/', gems)

  puts "Gems a serem travadas:\n#{locks}"

  locks.map do | lgem |
    unless lgem.nil?
      gemfile = gemfile.gsub(/(?<=gem ['"]#{lgem[:gem]})['"]$/, '\0, ' + "'#{lgem[:version]}'")
    end
  end

  puts gemfile

  access_file(path, gemfile)

  puts 'Gemfile atualizado com sucesso!'
end

main
