var SearchDiv = {
  enterMeansSearch: function(event){
    if (event.keyCode == Event.KEY_RETURN) {
        $('search_button').click();
        return false;
    }
    else {
        return true;
    }
  },
  
  searchForResults: function(by){
    $('spinner').show();
    new Ajax.Updater(
      'results', '/posts/get_results', {
        asynchronous:true, evalScripts:true, onSuccess:function(request){$('spinner').hide()},
        parameters: 'by=' + by + '&' + getAtcs() + 'drugtext=' + $F('drugtext')
      }
    );
  },

  observe: function(by){
    new Form.Element.Observer(
    'drugtext', 1.1, function(element, value) {
      new Ajax.Updater(
        'results', '/posts/get_results', {
          asynchronous:true, evalScripts:true, 
          parameters: 'by=' + by + '&' + getAtcs() + 'drugtext=' + encodeURIComponent(value) 
          }
        )
      }
    );
  },
  byBrandName: function(){
    $('searching_by').update('Brand Name');
    $('alt_search_link').update(
      '<a href="#" onclick="SearchDiv.byIngredient(); return false;">Search By Active Ingredient (Generic Name)</a>'
      );
    $('search_button').replace(
    '<input id="search_button" type="button" value="Search" onclick="SearchDiv.searchForResults(\'brandname\');"/>'
    );
  },
  byIngredient: function(){
    $('searching_by').update('Active Ingredient (Generic Name)');
    $('alt_search_link').update(
      '<a href="#" onclick="SearchDiv.byBrandName(); return false;">Search By Brand Name</a>'
      );
    $('search_button').replace(
    '<input id="search_button" type="button" value="Search" onclick="SearchDiv.searchForResults(\'ingredient\');"/>'
    );
  }
}

var ResultDiv = {
  lightUp: function(div){
    if (div.hasClassName('result')){
      div.removeClassName('result');
      div.addClassName('add');
      new Insertion.Bottom(div, '<p>Add to post</p>');
    }
  },
  backToNorm: function(div){
    if(div.hasClassName('add')){
      div.removeClassName('add');
      div.addClassName('result');
      div.down('p').remove();
    }
  },
  add: function(div){
    div.removeClassName('add');
    div.onclick = '';
    div.addClassName('added');
    var controller = $('controller_name').readAttribute('class');
    div.down('p').update('Added to post');
    var params = 'atc_code=' + div.down('span#atc_code').innerHTML;
    params += '&atc_class=' + div.down('span#atc_class').innerHTML + '&con_name=' + controller;
    new Ajax.Updater($('post_atcs'), '/posts/add_post_atc', {insertion: Insertion.Bottom, parameters: params });
  }
}

var PostForm = {
  deleteDrugRef: function(li, id) {
    li.hide();
    new Insertion.Bottom(li, 
      '<input id="post_drug_refs_attributes_' + id + '__delete" type="hidden" name="post[drug_refs_attributes][' + 
      id + '][_delete]" value="1"/>'
    );
  },
  toggle: function() {
    var container = $('form_container');
    var form = $$('#form_container form').first();
    if(container.hasClassName('active')) {
      form.visualEffect('blind_up', { duration: 0.25, afterFinish: function(){
        container.removeClassName('active');
      }});
    } else {
      form.visualEffect('blind_down', { duration: 0.5, beforeStart: function(){
        container.addClassName('active');
      }});
    }
  },
  newtoggle: function() {
    var container = $('form_container');
    var form = $('form_wrapper');
    if(container.hasClassName('active')) {
      form.visualEffect('blind_up', { duration: 0.25, afterFinish: function(){
        container.removeClassName('active');
      }});
    } else {
      form.visualEffect('blind_down', { duration: 0.5, beforeStart: function(){
        container.addClassName('active');
      }});
    }
  },
  autocomplete: function(textfield, div, action, field2) {
    new Ajax.Autocompleter(textfield, div, action,
        { minChars: 3,
          frequency: 0.4,
          paramName: 'drugtext',
          updateElement: function(selected) {
          Element.cleanWhitespace(selected);
          dn = selected.childNodes;
          $(textfield).value = dn[0].firstChild.nodeValue;
          $$(field2).first().value = dn[2].firstChild.nodeValue;
        } } );
   },
   autocomplete_three: function(textfield, div, action, field2, field3, param) {
    new Ajax.Autocompleter(textfield, div, action,
        { minChars: 3,
          frequency: 0.4,
          paramName: param,
          updateElement: function(selected) {
          Element.cleanWhitespace(selected);
          dn = selected.childNodes;
          $(textfield).value = dn[0].firstChild.nodeValue;
          $(field2).value = dn[1].firstChild.nodeValue;
          $$(field3).first().value = dn[2].firstChild.nodeValue;
        } } );
   }
}

var TDPostForm = {
  toggle: function(itemid) {
    var container = $$('#'+itemid+' div').first();
    var form = $$('#'+itemid+' form').first();
    if(container.hasClassName('active')) {
      form.visualEffect('blind_up', { duration: 0.25, afterFinish: function(){
        container.removeClassName('active');
      }});
    } else {
      form.visualEffect('blind_down', { duration: 0.5, beforeStart: function(){
        container.addClassName('active');
      }});
    }
  }
}

var EditTDPostForm = {
  toggle: function(itemid) {
    var container = $$('#edit'+itemid+' div').first();
    var form = $$('#edit'+itemid+' form').first();
    if(container.hasClassName('active')) {
      form.visualEffect('blind_up', { duration: 0.25, afterFinish: function(){
        container.removeClassName('active');
      }});
    } else {
      form.visualEffect('blind_down', { duration: 0.5, beforeStart: function(){
        container.addClassName('active');
      }});
    }
  }
}

function getAtcs(){
    var postAtcs = $$('#post_atcs li');
    var atcCodes = '';
    for (var i=0; i<postAtcs.length; i++){
      //atcCodes.push(postAtcs[i].down('.atc_code').innerHTML);
      atcCodes += 'atcs[]=' + postAtcs[i].down('.atc_code').innerHTML + '&'
    }
    return atcCodes;
  }
  
