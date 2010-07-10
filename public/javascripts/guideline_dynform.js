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

function add_to_drugbox() {
  var code_data = $(textbox).value.split("; ");
  var class_data = $(textbox).next('#condition_detail').value.split("; ");
  var str = "";
  for (var i = 0; i < (code_data.length - 1); i++) {
    str += "<li><span class='atc_code'>" + code_data[i] + "</span>&nbsp;";
    str += "<span class='atc_class'>" + class_data[i] + "</span>";
    str += "<a onclick=\"$(this).up('li').remove(); return false;\" href=\"#\">Remove from post</a></li>";
  };
  $('post_drug_refs').insert(str);
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
      height: '400'
    });
  };
};

function insertDrug() {
  var code_data = $$('.atc_code');
  var drug_codes = "";

  for (i=0; i < code_data.length; i++) {
    drug_codes += code_data[i].firstChild.nodeValue + "; ";
  }
  var class_html = '<input id="condition_detail" type="hidden" value="' + drug_classes + '" />';
  $(textbox).value = drug_codes;

  if ($(textbox).nextSiblings().length == 1) {
    $(textbox).up('li').insert({ bottom: class_html });
  }
  else {
    $(textbox).next('#condition_detail').value = drug_classes;
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
    var condition_detail = $$('#condition_detail');
    XML += '<guideline title="' + data.title.escapeHTML() + '" evidence="' + data.evidence.escapeHTML();
    XML += '" significance="' + data.significance.escapeHTML() + '"> <conditions> ';

    if (isString(data.condition_type)) {
      if (data.condition_type == "Drugs") {
        XML += '<condition type="' + data.condition_type + '" ' + data.condition_target.sub(' ', '');
        XML += '="' + data.condition_text.escapeHTML() + '_' + condition_detail[0].value.escapeHTML() + '"/> ';
      }
      else {
        XML += '<condition type="' + data.condition_type + '" ' + data.condition_target.sub(' ', '') + '="' + data.condition_text.escapeHTML() + '"/> ';
      }
    }
    else {
      for (var i = 0; i < data.condition_type.length; i++) {
        if (data.condition_type[i] == "Drugs") {
          XML += '<condition type="' + data.condition_type[i] + '" ' + data.condition_target[i].sub(' ', '');
          XML += '="' + data.condition_text[i].escapeHTML() + '_' + condition_detail[detail_index].value.escapeHTML() + '"/> ';
          detail_index++;
        }
        else {
          XML += '<condition type="' + data.condition_type[i] + '" ' + data.condition_target[i].sub(' ', '');
          XML += '="' + data.condition_text[i].escapeHTML() + '"/> ';
        }
      }
    }
    XML += '</conditions> <consequence> ';

    if (isString(data.warning_strength)) {
      XML += '<warning strength="' + data.warning_strength + '">' + data.warning_text.escapeHTML() + '</warning> ';
    }
    else {
      for (var j = 0; j < data.warning_strength.length; j++) {
        XML += '<warning strength="' + data.warning_strength[j] + '">' + data.warning_text[j].escapeHTML() + '</warning> ';
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
