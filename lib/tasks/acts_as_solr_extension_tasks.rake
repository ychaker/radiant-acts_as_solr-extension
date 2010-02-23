namespace :radiant do
  namespace :extensions do
    namespace :acts_as_solr do
      
      desc "Runs the migration of the Acts As Solr extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ActsAsSolrExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ActsAsSolrExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Acts As Solr to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from ActsAsSolrExtension"
        Dir[ActsAsSolrExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ActsAsSolrExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end
    end
  end
end
