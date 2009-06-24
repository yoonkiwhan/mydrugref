class Post < ActiveRecord::Base
  
  has_many   :comments,  :order => 'id', :dependent => :destroy
  has_many   :drug_refs, :dependent => :destroy
  has_many   :drugs, :through => :drug_refs
  has_many   :codes, :through => :drug_refs
  belongs_to :creator, :class_name => 'User', :foreign_key => "created_by"
  belongs_to :attachment, :dependent => :destroy
  accepts_nested_attributes_for :drug_refs, :allow_destroy => true
  
  def has_drug_ref
    if drug_refs.empty? or deleting_all_drug_refs
      errors.add(:drug_refs, "Must have at least one ATC Code attached")
    end
  end
  
  def deleting_all_drug_refs
    drug_refs.each do |d|
      unless d.marked_for_destruction?
        return false
      end
    end
    return true
  end
  
  def self.search(q, date, type)
    if type.nil?
      by_drug_name = Post.find(:all, :include => :drugs, 
                     :conditions => ['LOWER(cd_drug_product.brand_name) LIKE ? AND created_at > ?', 
                                     q.downcase, date])
      by_body = Post.find(:all, :conditions => ['LOWER(body) LIKE ? AND created_at > ?', q.downcase, date])
      by_atc = Post.find(:all, :include => :codes,
                     :conditions => ['LOWER(cd_therapeutic_class.tc_atc) LIKE ? AND created_at > ?',
                                     q.downcase, date])
    else
      by_drug_name = Post.find(:all, :include => :drugs, 
                     :conditions => ['LOWER(cd_drug_product.brand_name) LIKE ? AND type = ? AND created_at > ?', 
                                     q.downcase, type, date])
      by_body = Post.find(:all, :conditions => ['LOWER(body) LIKE ? AND type = ? AND created_at > ?', 
                                                q.downcase, type, date])
      by_atc = Post.find(:all, :include => :codes,
               :conditions => ['LOWER(cd_therapeutic_class.tc_atc) LIKE ? AND type = ? AND created_at > ?',
                               q.downcase, type, date])
    end
    by_drug_name | by_body | by_atc
  end

  def self.latest
    Post.find(:all, :order => "created_at DESC", :limit => 10)
  end

  def self.cemois
    Post.find(:all,
                 :conditions =>["created_at between ? AND ?", Time.now.at_beginning_of_month, Time.now],
                 :order => "created_at DESC")
  end

  # Creates an attachment from a file upload
  def file=(file)
    unless file.size == 0
      attachment=Attachment.new :content => file.read
      attachment.save
      write_attribute('attachment_id', attachment.id)
      write_attribute('attachment_filename', file.original_filename)
      write_attribute('attachment_content_type', file.content_type)
      write_attribute('attachment_size', file.size)
    end
  end
end
