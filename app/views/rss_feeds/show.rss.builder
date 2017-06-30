xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title Project.find(@rss_feed.subscription.project_id).title
    xml.description Project.find(@rss_feed.subscription.project_id).title + ' RSS feed.'
    xml.link root_url + Project.find(@rss_feed.subscription.project_id).slug

    @rss_urls.each do |r|
      xml.item do
        xml.title Project.find(@rss_feed.subscription.project_id).title
        xml.description Project.find(@rss_feed.subscription.project_id).title
        xml.pubDate r.created_at.to_s(:rfc822)
        xml.link 'https:' + r.file.url
        xml.guid 'https:' + r.file.url
      end
    end
  end
end
