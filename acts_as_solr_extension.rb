# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class ActsAsSolrExtension < Radiant::Extension
  version "1.0"
  description "Brings the functionality of the acts_as_solr Rails plugin to Radiant"
  url "http://github.com/ychaker/radiant-acts_as_solr-extension"
  
  AAS_YML = YAML::load_file(RAILS_ROOT + '/config/aas.yml')
  SOLR_MODELS = AAS_YML['models'].keys
  
  define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :apache_solr
  #   end
    map.search 'search', :controller => :solr_search, :action => :index
    map.add_facet 'add_facet', :controller => :solr_search, :action => :add_facet
    map.add_facet 'remove_facet', :controller => :solr_search, :action => :remove_facet
  end
  
  def activate
    # admin.tabs.add "Apache Solr", "/admin/apache_solr", :after => "Layouts", :visibility => [:all]
    SOLR_MODELS.each {
      |class_name|
      config = AAS_YML
      Object.const_get(class_name).class_eval{
        acts_as_solr  :fields => AAS_YML['models'][class_name]['fields'],
                      :facets => AAS_YML['models'][class_name]['facets']
      }
    }
  end
  
  def deactivate
    # admin.tabs.remove "Acts As Solr"
  end
  
end
