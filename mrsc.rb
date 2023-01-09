# Helper script for creating examples used in https://tech.showmax.com/2023/01/backend-developer-guide/ blog post.
#
# Usage:
#   ruby mrsc.rb <action>
#
# Available actions are init, example1, example2
#
require 'securerandom'

def edit(f, r = 5, a: true)
  File.open(f, a ? 'a' : 'w') do |file|
    (rand(r) + 1).times do
      file.puts SecureRandom.alphanumeric(rand(16) + 1)
    end
  end
end

def mkdir(p)
  Dir.mkdir(p) unless Dir.exist?(p)
end

def del(f)
  File.delete(f) if File.exist?(f)
end

def init
  mkdir('services')
  Dir.chdir('services') do
    3.times do |n|
      service = "service#{n}"
      mkdir(service)
      Dir.chdir(service) do
        mkdir('app')

        edit('service_file1.rb')
        Dir.chdir('app') do
          edit('app_file1.rb')
        end
      end
    end
  end

  mkdir('gems')
  Dir.chdir('gems') do
    mkdir('gem1')
    Dir.chdir('gem1') do
      edit('gem_file1.rb')
    end
  end
end

def example1
  Dir.chdir('services/service0') do
    Dir.chdir('app') do
      edit('app_file1.rb', a: false)
      edit('app_file2.rb')
    end
  end
  Dir.chdir('services/service2') do
    Dir.chdir('app') do
      edit('app_file2.rb')
    end
  end
end

def example2
  Dir.chdir('services') do
    3.times do |n|
      Dir.chdir("service#{n}") do
        case n
          when 0
            Dir.chdir('app') do
              edit('app_file1.rb', 50)
              edit('app_file3.rb', 50)
              del('app_file2.rb')
            end
          when 1
            Dir.chdir('app') do
              edit('app_file1.rb', a: false)
            end
          when 2
            Dir.chdir('app') do
              edit('app_file1.rb', 1)
              edit('app_file2.rb', 50)
            end

            mkdir('lib')
            Dir.chdir('lib') do
              edit('lib_file1.rb', 50)
            end

            edit('service_file1.rb')
        end
      end
    end
  end
  Dir.chdir('gems/gem1') do
    edit('gem_file1.rb')
  end
end

case ARGV[0]
  when 'init'
    init
  when 'example1'
    example1
  when 'example2'
    example2
  else
    puts 'Missing command (init, example1, example2)'
end
