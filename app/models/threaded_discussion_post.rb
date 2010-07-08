class ThreadedDiscussionPost < ActiveRecord::Base
  acts_as_nested_set #:scope => :root_id
  validates_presence_of :name, :created_by, :body
  belongs_to :creator, :class_name => 'User', :foreign_key => "created_by"

  def self.cemois
    ThreadedDiscussionPost.find(:all,
                                :conditions =>["created_at between ? AND ?", Time.now.at_beginning_of_month, Time.now],
                                :order => "created_at DESC")
  end

  def self.latest
    ThreadedDiscussionPost.find(:all, :order => "created_at DESC", :limit => 10)
  end

  def self.today
    ThreadedDiscussionPost.find(:all,
                                :conditions =>["created_at between ? AND ?", Time.today, Time.now],
                                :order => "created_at DESC")
  end

end
