module SolrSearchHelper
  def render_doc doc
    string = ""
		if(doc.class.to_s == "Page")
			page_fields = ActsAsSolrExtension::AAS_YML['models']["Page"]['fields'] - ["title"]
			page_part_fields = ActsAsSolrExtension::AAS_YML['models']["PagePart"]['fields']
			string += link_to doc.title, :controller => :site , :action => 'show_page', :id => doc.id
			page_fields.each do |each|
				string += render_field doc, each
			end
			page_part_fields.each do |each|
				string += render_field doc.parts.first, each
			end
		elsif(doc.class.to_s == "PagePart")
				page_fields = ActsAsSolrExtension::AAS_YML['models']["Page"]['fields'] - ["title"]
				page_part_fields = ActsAsSolrExtension::AAS_YML['models']["PagePart"]['fields']
				string += link_to doc.page.title, :controller => :site , :action => 'show_page', :id => doc.page.id
				page_fields.each do |each|
					string += render_field doc.page, each
				end
				page_part_fields.each do |each|
					string += render_field doc, each
				end
		else
			fields = ActsAsSolrExtension::AAS_YML['models'][doc.class.to_s]
			string += "<b>type:</b> " + doc.class.to_s
			fields.each do |each|
				string += render_field doc, each
			end
		end
		string
  end
  
  def render_facet facet, matches, facet_field, params, browse_array
    if !params[:browse].nil? && params[:browse].include?("#{facet_field}:#{facet}")
			link_to "(x) " + facet + " ("+ matches.to_s + ")", :controller => :solr_search, :action => :remove_facet, :query => params[:query], :model => params[:model], :browse => browse_array, :facet_field => facet_field, :facet => facet
    else
			return link_to facet + " ("+ matches.to_s + ")", :controller => :solr_search, :action => :add_facet, :query => params[:query], :model => params[:model], :browse => browse_array, :facet_field => facet_field, :facet => facet
		end
  end
  
private
  def render_field object, field_name
    if ActsAsSolrExtension::AAS_YML['render_blanks']
      return "<br /><b>" + field_name + ":</b> " + object.send(field_name)
    elsif object.send(field_name).empty?
      return ''
    else
     return  "<br /><b>" + field_name + ":</b> " + object.send(field_name) 
    end
  end
end
