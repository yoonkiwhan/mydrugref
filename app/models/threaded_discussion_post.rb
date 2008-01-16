class ThreadedDiscussionPost < ActiveRecord::Base
   acts_as_nested_set :scope => :root_id
   validates_presence_of :name, :created_by, :body
end
