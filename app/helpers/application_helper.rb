module ApplicationHelper
  def page_id
    if controller.class.name =~ /^(\w+)Controller$/
      "page-#{$1.tableize}"
    end
  end

  def facet_links(selection, facet, options)
    out = ''
    current_label = (value = selection.send(facet)) ? options[value] : options.first[1]
    out << link_to(current_label, '#')
    out << '<ul>'
    options.each do |value, label|
      out << "<li>#{link_to(label, { :controller => "#{selection.resource_name}s", :action => :index }.merge(selection.merge(facet => value)))}</li>"
    end
    out << '</ul>'
  end

  def tweet_button(text, url)
    <<-EOHTML
       <a href="https://twitter.com/share" class="twitter-share-button"
          data-url="#{url}"
          data-via="appsterdamrs"
          data-text="#{text}"
          data-count="none">Tweet</a>
    EOHTML
  end
end
