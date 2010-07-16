var DxDiv = {
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
    var dxCode = div.down('span#dx_code').innerHTML;
    var dxDesc = div.down('span#dx_desc').innerHTML;

    DxDiv.makeItGrey(div);
    
    str = "<li><span class='dx_code'>" + dxCode + "</span>&nbsp;";
    str += "<span class='dx_desc'>" + dxDesc + "</span>";
    str += "<a onclick=\"$(this).up('li').remove(); return false;\" href=\"#\">Remove from post</a></li>";
    
    $('post_dxcodes').insert(str);
  }
}

document.observe('dom:loaded', function() {
  $$('#form_wrapper form')[0].observe('submit', function(e) {
    Event.stop(e);
    to_xml();
  });
});

function appendToElement(field, from) {
    new Ajax.Updater(field, from, { insertion: Insertion.Bottom });
};

var textbox;
function add_to_box(code_class, desc_class, insert_tag) {
  var code_data = $(textbox).value.split(", ");
  var class_data = $(textbox).next('#detail').value.split(", ");
  var str = "";
  for (var i = 0; i < code_data.length; i++) {
    if (code_data[i].slice(0, 3) == 'atc') {
      str += "<li><span class='" + code_class + "'>" + code_data[i].slice(4) + "</span>&nbsp;";
    }
    else {
      str += "<li><span class='" + code_class + "'>" + code_data[i] + "</span>&nbsp;";
    }
    str += "<span class='" + desc_class + "'>" + class_data[i] + "</span>";
    str += "<a onclick=\"$(this).up('li').remove(); return false;\" href=\"#\">Remove from post</a></li>";
  };

  $(insert_tag).insert(str);
};

function drugBox(link) {
  var between = $(link).previous('select');
  var target = between.previous('select');
  textbox = link;

  if ($F(target) == "Drugs") {
    myLightWindow.activateWindow({
      href: '/Guidelines/drug_search',
      title: 'Please select relevant drugs.',
      type: 'page',
      width: '500',
      height: '400',
      afterComplete: "add_to_box('atc_code', 'atc_class', 'post_drug_refs')"
    });
  }
  else if ($F(target) == "Dxcodes") {
    myLightWindow.activateWindow({
      href: '/Guidelines/dx_search',
      title: 'Please select relevant dxcodes.',
      type: 'page',
      width: '500',
      height: '400',
      afterComplete: "add_to_box('dx_code', 'dx_desc', 'post_dxcodes')"
    });
  }
};

function insertToPage(code_class, desc_class, prepend) {
  var code_class_name = '.' + code_class;
  var desc_class_name = '.' + desc_class;
  var code_data = $$(code_class_name);
  var class_data = $$(desc_class_name);
  var code_array = new Array();
  var class_array = new Array();

  for (i=0; i < code_data.length; i++) {
    code_array[i] = prepend + code_data[i].firstChild.nodeValue;
    class_array[i] = class_data[i].firstChild.nodeValue;
  }

  var codes = code_array.join(", ");
  var descs = class_array.join(", ");

  alert(codes + "   ---   " + descs);
  var desc_html = '<input id="detail" type="hidden" value="' + descs + '" />';
  $(textbox).value = codes;

  if ($(textbox).nextSiblings().length == 1) {
    $(textbox).up('li').insert({ bottom: desc_html });
  }
  else {
    $(textbox).next('#detail').replace = desc_html;
  }

  textbox = null;
  myLightWindow.deactivate();
}

function isString() {
  if (typeof arguments[0] == 'string') return true;
  if (typeof arguments[0] == 'object') {
    var criterion = arguments[0].constructor.toString().match(/string/i); 
    return (criterion != null);  }return false;
}

function submit(name, body, reference, uuid, g_id, method) {
  if (method == 'update') {
    var url = '/guidelines/' + g_id
    new Ajax.Request(url, {
      method: 'post',
      parameters: {'post[name]': name,
                   'post[body]': body,
                   'post[reference]': reference,
                   'post[uuid]': uuid,
                   '_method': 'put'  }
    })
  }
  else if (method == 'create'){
    new Ajax.Request('/guidelines', {
      method: 'post',
      parameters: {'post[name]': name,
                   'post[body]': body,
                   'post[reference]': reference }
    });
  }
}

function to_xml() {
  if (validate_form()) {
    var form = $$('#form_wrapper form')[0];
    var data = form.serialize().parseQuery();
    var method = Form.Element.getValue($('method'));
    if (method == 'update') {
      var uuid = $('uuid').value;
      var g_id = $('g_id').value;
    }
    else if (method == 'create') {
      var uuid = null;
      var g_id = null;
    }
    
    var XML = '';
    var detail_index = 0;
    var condition_detail = $$('#detail');
    XML += '<guideline title="' + data.title.escapeHTML() + '" evidence="' + data.evidence.escapeHTML();
    XML += '" significance="' + data.significance.escapeHTML() + '"> <conditions> ';

    if (isString(data.condition_type)) {
      if (data.condition_type == "Drugs" || data.condition_type == "Dxcodes") {
        XML += '<condition type="' + data.condition_type.toLowerCase() + '" ' + data.condition_target.sub(' ', '').toLowerCase();
        XML += '="' + data.condition_text.escapeHTML() + '" desc="' + condition_detail[0].value.escapeHTML() + '"/> ';
      }
      else {
        XML += '<condition type="' + data.condition_type.toLowerCase() + '" ' + data.condition_target.sub(' ', '').toLowerCase() + '="' + data.condition_text.escapeHTML() + '"/> ';
      }
    }
    else {
      for (var i = 0; i < data.condition_type.length; i++) {
        if (data.condition_type[i] == "Drugs" || data.condition_type[i] == "Dxcodes") {
          XML += '<condition type="' + data.condition_type[i].toLowerCase() + '" ' + data.condition_target[i].sub(' ', '').toLowerCase();
          XML += '="' + data.condition_text[i].escapeHTML() + '" desc="' + condition_detail[detail_index].value.escapeHTML() + '"/> ';
          detail_index++;
        }
        else {
          XML += '<condition type="' + data.condition_type[i].toLowerCase() + '" ' + data.condition_target[i].sub(' ', '').toLowerCase();
          XML += '="' + data.condition_text[i].escapeHTML() + '"/> ';
        }
      }
    }
    XML += '</conditions> <consequence> ';

    if (isString(data.warning_strength)) {
      XML += '<warning strength="' + data.warning_strength.toLowerCase() + '">' + data.warning_text.escapeHTML() + '</warning> ';
    }
    else {
      for (var j = 0; j < data.warning_strength.length; j++) {
        XML += '<warning strength="' + data.warning_strength[j].toLowerCase() + '">' + data.warning_text[j].escapeHTML() + '</warning> ';
      }
    }
    XML += '</consequence> </guideline>';
    
    submit(data.title, XML, data.reference, uuid, g_id, method);
  };
};

function validate_form() {
  var error_message = "Please fix the following errors and resubmit:\n\n";
  var validates = true;

  if ($('title').value == "") {
    validates = false;
    $('title').addClassName('validate_fail');
    error_message += "  - The title can not be empty.\n";
  }
  else {
    $('title').removeClassName('validate_fail');
  }

  var cond_text_array = $$('#condition_text');
  for (var i = 0; i < cond_text_array.length; i++) {
    if ($(cond_text_array[i]).value == "") {
      validates = false;
      $(cond_text_array[i]).addClassName('validate_fail');
      error_message += "  - There cannot be any empty fields in conditions.\n";
      break;
    }
    else {
      $(cond_text_array[i]).removeClassName('validate_fail');
    }
  }

  var warn_text_array = $$('#warning_text');
  for (var i = 0; i < warn_text_array.length; i++) {
    if ($(warn_text_array[i]).value == "") {
      validates = false;
      $(warn_text_array[i]).addClassName('validate_fail');
      error_message += "  - There cannot be any empty fields in consequences.\n";
      break;
    }
    else {
      $(warn_text_array[i]).removeClassName('validate_fail');
    }
  }

  if ($("reference").value != "") {
    var regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
    if (regexp.test($("reference").value) == false) {
      validates = false;
      $('reference').addClassName('validate_fail');
      error_message += "  - The reference must be a valid URL (Needs to start with ftp/http/https).\n";
    }
    else {
      $('reference').removeClassName('validate_fail');
    }
  };

  if (validates == false) {
    alert(error_message);
  }

  return validates;
};

function enterMeansSearch(event) {
  if (event.keyCode == Event.KEY_RETURN) {
      $('search_button').click();
      return false;
  }
  else {
      return true;
  }
}

function searchForResults() {
  $('spinner').show();
  var table = $('search_param').value
  new Ajax.Updater('results', '/Guidelines/get_dxcodes', {
            asynchronous: true, 
            evalScripts: true, 
            onSuccess: function(request) { $('spinner').hide() },
            parameters: 'in=' + table + '&' + getDxCodes() + 'dxtext=' + $F('dxtext')
            });
}

function getDxCodes() {
  var postDxcodes = $$('#post_dxcodes li');
  dxcodes = "";

  for (var i=0; i < postDxcodes.length; i++){
    dxcodes += 'dxcodes[]=' + postDxcodes[i].down('.dx_code').innerHTML + '&'
  }

  return dxcodes;
}
