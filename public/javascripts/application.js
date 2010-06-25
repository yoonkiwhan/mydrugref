var DynamicForm = {
    addField: function(field, area) {
      if(!document.getElementById) return;

      var field_area = document.getElementById(area);
      var all_inputs = field_area.getElementsByTagName("input");
      var last_item = all_inputs.length - 1;
      var count = Number(last.split("_")[1]) + 1;

      if(document.createElement) {
        var list = document.createElement("li");
        var input = document.createElement("input");
        input.id = field+count;
        input.name = field+count;
        input.type = "text";
        list.appendChild(input);
        field_area.appendChild(list);
      } else {
        field_area.innerHTML += "<li><input name='"+(field+count)+"' id='"+(field+count)+"' type='text' /></li>";
      }
  }
}


var InteractionForm = {
    searchForMore: function(label){
      var searchStuff = '<p id="helptext">Search for the drug in the Health Canada Database below. <br />' +
        'Click on a result to add it to your post.</p>' +
        '<div class="search"><span id="searching_by">Brand Name</span>' +
        '<input id="drugtext" name="drugtext" type="text" onkeypress="SearchDiv.enterMeansSearch(event);">' +
        '<input id="search_button" onclick="SearchDiv.searchForResults(\'brandname\');" type="button" ' +
        'value="Search" />' +
        '<img id="spinner" style="display: none;" src="/images/spinner.gif" />' +
        '<span id="alt_search_link">' +
    '<a href="#" onclick="SearchDiv.byIngredient(); return false;">Search By Active Ingredient (Generic Name)</a>' +
        '</span><div id="results"></div></div>';
      
      if (label == 'int_drug1'){
        $('affecting').insert({ 'top' : searchStuff });
        if ($('affected').down('.search') != null){
          $('affected').down('.search').remove();
          $('affected').down('p#helptext').remove();
          $('affected').insert(
          { 'bottom' : '<a href="#" onclick="InteractionForm.searchForMore(\'int_drug2\'); $(this).remove(); return false;">Search for more</a>'}
          );
        }
      } else {
        $('affected').insert({ 'top' : searchStuff });
        if ($('affecting').down('.search') != null){
          $('affecting').down('.search').remove();
          $('affecting').down('p#helptext').remove();
          $('affecting').insert(
          { 'bottom' : '<a href="#" onclick="InteractionForm.searchForMore(\'int_drug1\'); $(this).remove(); return false;">Search for more</a>'}
          );
        }
      }
    },
    
    add: function(div, atcCode, atcClass){
      if (div.up(2).readAttribute('id') == 'affecting'){
        var value = 'int_drug1';
      } else {
        var value = 'int_drug2';
      }
      
      var results = div.up('#results');
      results.update();
      var contents = results.up(1).innerHTML;
      results.up().previous().remove();
      var list = results.up().next();
      list.insert(
        '<li><span class="atc_code">' + atcCode + '</span>' + 
        '&nbsp<span class="atc_class">' + atcClass + '</span>' +
        '<a href="#" onclick="InteractionForm.removeAtc($(this).up(\'li\'), \'' + atcCode + '\')">Remove</a></li>'
        );
      results.up().remove();
      
      list.up().insert(
        '<a href="#" onclick="InteractionForm.searchForMore(\'' + 
        value + '\'); $(this).remove(); return false;">Search for more</a>');
      
      $('hidden_drug_ref_inputs').insert(
        '<div id="' + atcCode + '">' +
        '<input id="post_drug_refs_attributes_' + atcCode + '_tc_atc_number" ' + 
        'name="post[drug_refs_attributes][' + atcCode + '][tc_atc_number]" ' + 
        'value="' + atcCode + '" type="hidden" class="atc_code" />' +
        '<input id="post_drug_refs_attributes_' + atcCode + '_label" ' +
        'name="post[drug_refs_attributes][' + atcCode + '][label]" value="' + value + '" type="hidden" />' +
        '</div>'
      );
      
      // If there aren't any affected atcs
      if (value == 'int_drug1' && $('affected').childElements().length == 1){
        // contents minus the list's atc info
        $('affected').update(
          contents.slice(0, contents.indexOf('<li')) + '</ul>'
          );
      // else if there aren't any affecting atcs
      } else if (value == 'int_drug2' && $('affecting').down('.int_atcs').down() == null) {
        $('affecting').update(
          contents.slice(0, contents.indexOf('<ul')) + '<ul class="int_atcs"></ul>'
          );
      }
   },
   
   removeAtc: function(li, atc){
     li.remove();
     $('hidden_drug_ref_inputs').down('div#' + atc).remove();
   }
}

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
  
  getPricesResults: function(by){
    if (by == 'brandname'){
      var url = '/prices/get_results_by_brand';
    }
    else {
      var url = '/prices/get_results_by_ingredient';
    }
    $('spinner').show();
    new Ajax.Updater(
      'results', url, {
        asynchronous:true, evalScripts:true, onSuccess:function(request){$('spinner').hide()},
        parameters: 'drugtext=' + $F('drugtext')
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
  },
  
  priceByIngredient: function(){
    $('searching_by').update('Active Ingredient (Generic Name)');
    $('alt_search_link').update(
      '<a href="#" onclick="SearchDiv.priceByBrandName(); return false;">Search By Brand Name</a>'
      );
    $('search_button').replace(
    '<input id="search_button" type="button" value="Search" onclick="SearchDiv.getPricesResults(\'ingredient\');"/>'
    );
  },
  
  priceByBrandName: function(){
    $('searching_by').update('Brand Name');
    $('alt_search_link').update(
      '<a href="#" onclick="SearchDiv.priceByIngredient(); return false;">' + 
      'Search By Active Ingredient (Generic Name)</a>'
      );
    $('search_button').replace(
    '<input id="search_button" type="button" value="Search" onclick="SearchDiv.getPricesResults(\'brandname\');"/>'
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
  makeItGrey: function(div){
    div.removeClassName('add');
    div.onclick = '';
    div.addClassName('added');
    div.down('p').update('Added to post');
  },
  add: function(div){
    var controller = $('controller_name').readAttribute('class');
    var atcCode = div.down('span#atc_code').innerHTML;
    var atcClass = div.down('span#atc_class').innerHTML;
    
    if (controller == 'interactions') {
      InteractionForm.add(div, atcCode, atcClass);     
    } else {
      ResultDiv.makeItGrey(div);
      var params = 'atc_code=' + atcCode + '&atc_class=' + atcClass + '&con_name=' + controller;
      new Ajax.Updater(
        $('post_drug_refs'), '/posts/add_post_atc', {insertion: Insertion.Bottom, parameters: params }
      );
    }
  },
  addToPrice: function(div){
    var results = div.up('#results');
    results.update(div);
    results.insert('Price can only be attached to one drug.');
    var search_div = results.up('.search');
    var drug_input = search_div.down('#drugtext');
    drug_input.writeAttribute('readonly', 'readonly');
    drug_input.value = '';
    search_div.down('#search_button').writeAttribute('onclick', '');
    search_div.down('#alt_search_link').update();
    ResultDiv.makeItGrey(div);
    var params = 'brand_name=' + div.down('span#brand_name').innerHTML + 
    '&atc_code=' + div.down('span#price_atc').innerHTML +'&din=' + div.down('span#din').innerHTML.slice(1, -1);
    new Ajax.Updater($('post_drug_refs'), '/prices/add_price_drug', 
                     {insertion: Insertion.Bottom, parameters: params });
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
  removeNewPriceDrug: function(div) {
    div.remove();
    // make search possible again:
    $('results').update();
    $('drugtext').removeAttribute('readonly');
    $('search_button').writeAttribute('onclick', 'SearchDiv.getPricesResults("brandname")');
    $('alt_search_link').update(
      '<a href="#" onclick="SearchDiv.priceByIngredient(); return false;">Search By Active Ingredient ' +
      '(Generic Name)</a>');
    $('searching_by').update('Brand Name');
  },
  deletePriceDrugRef: function(li, id) {
    li.hide();
    new Insertion.Bottom(li, 
      '<input id="post_drug_refs_attributes_' + id + '__delete" type="hidden" name="post[drug_refs_attributes][' + 
      id + '][_delete]" value="1"/>'
    );
    $('results').update();
    $('drugtext').removeAttribute('readonly');
    $('search_button').writeAttribute('onclick', 'SearchDiv.getPricesResults("brandname")');
    $('alt_search_link').update(
      '<a href="#" onclick="SearchDiv.priceByIngredient(); return false;">Search By Active Ingredient ' +
      '(Generic Name)</a>');
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
    var atcCodes = '';
    if ($('controller_name').hasClassName('interactions')) {
    
      var postAtcs = $$('#hidden_drug_ref_inputs input.atc_code');
      for (var i=0; i<postAtcs.length; i++){
        atcCodes += 'atcs[]=' + $F(postAtcs[i]) + '&'
      }
    
    } else {
    
    var postAtcs = $$('#post_drug_refs li');
    
    for (var i=0; i<postAtcs.length; i++){
      //atcCodes.push(postAtcs[i].down('.atc_code').innerHTML);
      atcCodes += 'atcs[]=' + postAtcs[i].down('.atc_code').innerHTML + '&'
    }
    
    }
    
    return atcCodes;
  }
  
