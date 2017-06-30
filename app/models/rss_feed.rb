class RssFeed < ActiveRecord::Base
  include Hashid::Rails
  belongs_to :subscription
end
