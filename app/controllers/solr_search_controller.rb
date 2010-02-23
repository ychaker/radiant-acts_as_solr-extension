class SolrSearchController < ApplicationController
  skip_before_filter :verify_authenticity_token
  no_login_required
  
  def index
    query = params[:query]
    model = params[:model]
    browse = params[:browse]
    @search_models = ActsAsSolrExtension::SOLR_MODELS
    
    if !model.nil? && model == "Page"
      @results = Page.multi_solr_search query, :models => ["Page", "PagePart"]
    elsif !model.nil? && model != "All"
      @results= Object.const_get(model).find_by_solr query, 
                                            :facets => {  
                                                  :zeros => false, :sort => true, 
                                                  :fields => ActsAsSolrExtension::AAS_YML['models'][model]["facets"],
                                                  :browse => browse
                                            }
    else
      @results = Page.multi_solr_search query, :models => @search_models
    end
    @browse_array = browse.map { |each| each.sub(/_facet/, '') } unless browse.nil?
  end
  
  def add_facet
    query = params[:query]
    model = params[:model]
    browse = params[:browse].nil? ? [] : params[:browse]
    field =  params[:facet_field].sub(/_facet/, '')
    facet = params[:facet]
    browse += ["#{field}:#{facet}"]
    redirect_to :action => :index, :params => {:query => query, :model => model, :browse => browse}
  end
  
  def remove_facet
    query = params[:query]
    model = params[:model]
    browse = params[:browse].nil? ? [] : params[:browse]
    field =  params[:facet_field].sub(/_facet/, '')
    facet = params[:facet]
    browse -= ["#{field}:#{facet}"]
    redirect_to :action => :index, :params => {:query => query, :model => model, :browse => browse}
  end
  
end
