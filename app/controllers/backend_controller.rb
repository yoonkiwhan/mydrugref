class BackendController < ApplicationController
  web_service_api OscarApi
  web_service_scaffold :invoke

  def fetch(methods, atcs, email="none", inclusive=true)
   
    email == "none" ? user = nil : user = User.find_by_email(email)
    
    unless user.nil?
      trusted_ids = ([user] + user.friends).collect {|u| u.id}
    end
    
    drug_refs = DrugRef.find_all_by_tc_atc_number(atcs.slice!(0))
    for atc in atcs
      drug_refs += DrugRef.find_all_by_tc_atc_number(atc)
    end

    results = []

    if methods.include?("interactions_byATC")
      for dr in drug_refs.find_all {|d| d.label == 'int_drug1'}
        for dr2 in drug_refs.find_all { |d| d.label == 'int_drug2'}
          if dr.post == dr2.post
            user.nil? ? trusted = false : trusted = mark_trusted(dr.post, trusted_ids)
            unless !trusted and !inclusive
              results << make_oscar_interaction(dr.post, trusted)
            end
          end
        end
      end
    end

    if methods.include?("warnings_byATC")
      for dr in drug_refs.find_all {|d| d.label == 'Warning'}
        user.nil? ? trusted = false : trusted = mark_trusted(dr.post, trusted_ids)
        unless !trusted and !inclusive
          results << make_oscar_warning(dr.post, trusted)
        end
      end
    end

    if methods.include?("bulletins_byATC")
      for dr in drug_refs.find_all {|d| d.label == 'Bulletin'}
        user.nil? ? trusted = false : trusted = mark_trusted(dr.post, trusted_ids)
        unless !trusted and !inclusive
          results << make_oscar_bulletin(dr.post, trusted)
        end
      end
    end
    
    if methods.include?("prices_byATC")
      for dr in drug_refs.find_all {|d| d.label == 'Price'}
        user.nil? ? trusted = false : trusted = mark_trusted(dr.post, trusted_ids)
        unless !trusted and !inclusive
          results << make_oscar_price(dr.post, trusted)
        end
      end
    end
  
#    if methods.include?("get_guidelines")
#      for g in Guideline.all
#        user.nil? ? trusted = false : trusted = mark_trusted(g, trusted_ids)
#        unless !trusted and !inclusive
#          results << make_oscar_guideline(g, trusted)
#        end
#      end
#    end

    results

  end

  
  def get_treatments(query, email="none", inclusive=true)
    
    # Had to add this, because Oscar passes in (query, email, nil)
    inclusive.nil? ? inclusive = true : inclusive = inclusive
    
    email == "none" ? user = nil : user = User.find_by_email(email)
    
    unless user.nil?
      trusted_ids = ([user] + user.friends).collect {|u| u.id}
    end
    
    results = []
  
    query = ('%' + query + '%').gsub(' ', '%')
    for treatment in Treatment.find(:all, :conditions => [ 'LOWER(name) LIKE ?', query.downcase])
      user.nil? ? trusted = false : trusted = mark_trusted(treatment, trusted_ids)
      unless !trusted and !inclusive
        results << make_oscar_treatment(treatment, trusted)
      end
    end
    results
  end
  
  
  def thumbs_up_from_friend(post, trusted_ids)
     unless post.comments.nil?
       for comment in post.comments
          if trusted_ids.include?(comment.created_by) and comment.agree
             return true
          end
       end
     end
     return false
  end
  
  
  def mark_trusted(post, trusted_ids)
     (trusted_ids.include?(post.created_by) or thumbs_up_from_friend(post, trusted_ids)) ? true : false
  end
  
  
  def make_oscar_treatment(post, trusted)
    Oscarresult.new(:name => post.name, :author => post.creator.name, :created_at => post.created_at,
                    :updated_at => post.updated_at, :body => post.body, :type => 'Treatment', :trusted => trusted,
                    :drugs => make_oscar_drugs(post.drug_refs), :comments => make_oscar_comments(post.comments))
  end
  
  
  def make_oscar_drugs(drug_refs)
    results = []
    for dr in drug_refs
      results << OscarDrug.new(:brand_name => dr.drug.brand_name, 
                               :drug_identification_number => dr.drug_identification_number,
                               :atc => dr.tc_atc_number, :label => dr.label)
    end
    results
  end


  def make_oscar_interaction(post, trusted)
    Oscarresult.new(:id => post.id, :created_at => post.created_at, :updated_at => post.updated_at, 
                    :created_by => post.created_by, :updated_by => post.updated_by, :body => post.body, 
                    :name => post.affecting_drug.brand_name, :atc => post.affecting_dr.tc_atc_number, 
                    :drug2 => post.affected_drug.brand_name, :atc2 => post.affected_dr.tc_atc_number, 
                    :effect => post.effect, :evidence => post.evidence, :reference => post.reference, 
                    :significance => post.significance, :type => 'Interaction', :trusted => trusted, 
                    :author => post.creator.name, :comments => make_oscar_comments(post.comments))
  end

  
  def make_oscar_warning(post, trusted)
    Oscarresult.new(:id => post.id, :created_at => post.created_at, :updated_at => post.updated_at, 
                    :created_by => post.created_by, :updated_by => post.updated_by, :body => post.body, 
                    :name => post.drugs[0].brand_name, :atc => post.drug_refs[0].tc_atc_number, 
                    :effect => post.effect, :evidence => post.evidence, :reference => post.reference, 
                    :significance => post.significance, :trusted => trusted, :type => 'Warning', 
                    :author => post.creator.name, :comments => make_oscar_comments(post.comments))
  end
  

  def make_oscar_bulletin(post, trusted)
    Oscarresult.new(:id => post.id, :created_at => post.created_at, :updated_at => post.updated_at, 
                    :created_by => post.created_by, :updated_by => post.updated_by, :body => post.body, 
                    :name => post.drugs[0].brand_name, :atc => post.drug_refs[0].tc_atc_number, 
                    :effect => post.effect, :evidence => post.evidence, :reference => post.reference, 
                    :significance => post.significance, :trusted => trusted, :type => 'Bulletin',
                    :news_source => post.news_source, :news_date => post.news_date, 
                    :author => post.creator.name, :comments => make_oscar_comments(post.comments))
  end
  
  def make_oscar_price(post, trusted)
    Oscarresult.new(:id => post.id, :created_at => post.created_at, :updated_at => post.updated_at, 
                    :created_by => post.created_by, :updated_by => post.updated_by, 
                    :name => post.name, :reference => post.reference, :cost => post.cost, :trusted => trusted, 
                    :type => 'Price', :author => post.creator.name, :comments => make_oscar_comments(post.comments))
  end
  

  def make_oscar_guideline(post, trusted)
    Oscarresult.new(:id => post.id, :created_at => post.created_at, :updated_at => post.updated_at, 
                    :created_by => post.created_by, :updated_by => post.updated_by, :body => post.body, 
                    :name => post.name, :author => post.creator.name, :type => 'Guideline',
                    :comments => make_oscar_comments(post.comments), :trusted => trusted)
  end
  

  def make_oscar_comments(comments)
     results = []    
     for comment in comments
       results << Oscarresult.new(:id => comment.id, :created_at => comment.created_at, 
                                  :updated_at => comment.updated_at, :created_by => comment.created_by, 
                                  :updated_by => comment.updated_by, :body => comment.body, 
                                  :name => comment.name, :agree => comment.agree, :author => comment.creator.name)
     end   
     results
  end
  
end