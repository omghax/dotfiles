require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

module VIM
  DIRS = %w[
    vim/autoload
    vim/bundle
  ].freeze
end

directory 'tmp'
VIM::DIRS.each do |dir|
  directory(dir)
end

def vim_plugin_task(name, repo=nil)
  dir = File.expand_path("tmp/#{name}")
  bundle_target = File.expand_path("vim/bundle/#{name}")
  subdirs = VIM::DIRS

  namespace(name) do
    if repo
      file dir => 'tmp' do
        if repo =~ /git$/
          sh "git clone #{repo} #{dir}"
        elsif repo =~ /download_script/
          if filename = `curl --silent --head #{repo} | grep attachment`[/filename=(.+)/,1]
            filename.strip!
            sh "curl #{repo} > tmp/#{filename}"
          else
            raise ArgumentError, 'unable to determine script type'
          end
        elsif repo =~ /(tar|gz|zip|vim)$/
          filename = File.basename(repo)
          sh "curl #{repo} > tmp/#{filename}"
        else
          raise ArgumentError, 'unrecognized source URL for plugin'
        end

        case filename
        when /zip$/
          sh "unzip -o tmp/#{filename} -d #{dir}"
        when /tar\.gz$/
          dirname = File.basename(filename, '.tar.gz')
          sh "tar zxvf tmp/#{filename}"
          sh "mv #{dirname} #{dir}"
        when /vim(\.gz)?$/
          if filename =~ /gz$/
            sh "gunzip -f tmp/#{filename}"
            filename = File.basename(filename, '.gz')
          end
        end
      end

      task :pull => dir do
        if repo =~ /git$/
          Dir.chdir(dir) do
            sh "git pull"
          end
        end
      end

      task :install => [:pull] + subdirs do
        mkdir_p(bundle_target)
        sh "cp -Rf #{dir}/* #{bundle_target}/"
        Dir.chdir(bundle_target) do
          yield if block_given?
        end
      end
    else
      task :install => subdirs do
        yield if block_given?
      end
    end
  end

  desc "Install #{name} plugin"
  task(name) do
    puts
    puts '*' * 40
    puts "*#{"Installing #{name}".center(38)}*"
    puts '*' * 40
    puts
    Rake::Task["#{name}:install"].invoke
  end
  task :vim => name
end

vim_plugin_task 'pathogen.vim' do
  file 'pathogen.vim' => 'autoload' do
    sh 'curl -fL https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim > vim/autoload/pathogen.vim'
  end
end

vim_plugin_task 'ack.vim',        'git://github.com/mileszs/ack.vim.git'
vim_plugin_task 'bufexplorer',    'git://github.com/jlanzarotta/bufexplorer.git'
vim_plugin_task 'coffeescript',   'git://github.com/kchmck/vim-coffee-script.git'
vim_plugin_task 'color-sampler',  'git://github.com/vim-scripts/Colour-Sampler-Pack.git'
vim_plugin_task 'ctrlp',          'git://github.com/kien/ctrlp.vim.git'
vim_plugin_task 'emmet',          'git://github.com/mattn/emmet-vim.git'
vim_plugin_task 'endwise',        'git://github.com/tpope/vim-endwise.git'
vim_plugin_task 'fugitive',       'git://github.com/tpope/vim-fugitive.git'
vim_plugin_task 'git',            'git://github.com/tpope/vim-git.git'
vim_plugin_task 'haml',           'git://github.com/tpope/vim-haml.git'
vim_plugin_task 'indent-object',  'git://github.com/michaeljsmith/vim-indent-object.git'
vim_plugin_task 'javascript',     'git://github.com/pangloss/vim-javascript.git'
vim_plugin_task 'jshint',         'git://github.com/wookiehangover/jshint.vim.git'
vim_plugin_task 'markdown',       'git://github.com/tpope/vim-markdown.git'
vim_plugin_task 'mustache',       'git://github.com/juvenn/mustache.vim.git'
vim_plugin_task 'nerdcommenter',  'git://github.com/ddollar/nerdcommenter.git'
vim_plugin_task 'nerdtree',       'git://github.com/wycats/nerdtree.git'
vim_plugin_task 'ragel',          'git://github.com/jayferd/ragel.vim.git'
vim_plugin_task 'rails',          'git://github.com/tpope/vim-rails.git'
vim_plugin_task 'ruby',           'git://github.com/vim-ruby/vim-ruby.git'
vim_plugin_task 'sensible',       'git://github.com/tpope/vim-sensible.git'
vim_plugin_task 'solarized',      'git://github.com/altercation/vim-colors-solarized.git'
vim_plugin_task 'supertab',       'git://github.com/ervandew/supertab.git'
vim_plugin_task 'surround',       'git://github.com/tpope/vim-surround.git'
vim_plugin_task 'tabular',        'git://github.com/godlygeek/tabular.git'
vim_plugin_task 'unimpaired',     'git://github.com/tpope/vim-unimpaired.git'
vim_plugin_task 'vroom',          'git://github.com/skalnik/vim-vroom.git'
