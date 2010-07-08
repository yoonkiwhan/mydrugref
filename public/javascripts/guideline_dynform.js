Event.observe(window, "load", function() {
  new RSV({
    formID: "new_guideline",
    onCompleteHandler: to_xml,
    rules: [
      "required,title,Please enter a title for the guideline"
    ]
  });
});

function appendToElement(field, from) {
    new Ajax.Updater(field, from, { insertion: Insertion.Bottom });
};

var textbox;

function drugBox(link) {
  var between = $(link).previous('select');
  var target = between.previous('select');
  textbox = link;
  var codes = $(textbox).value.split("; ");
  var param = "?atc=";
  for (var i=0; i < (codes.length - 2); i++) {
    param += codes[i] + "_";
  }
  param += codes[i];
  var url = '/Guidelines/drug_search' + param;

  if ($F(target) == "Drugs") {
    myLightWindow.activateWindow({
      href: url,
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

  $(textbox).value = drug_codes;
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
  var form = $$('#form_wrapper form')[0];
  var data = form.serialize().parseQuery();
  var method = Form.Element.getValue($('method'));
  if (method == 'update') {
    var uuid = Form.Element.getValue($('uuid'));
    var g_id = Form.Element.getValue($('g_id'));
  }
  else if (method == 'create') {
    var uuid = null;
    var g_id = null;
  }
  var XML = '';
  XML += '<guideline title="' + data.title.escapeHTML() + '" evidence="' + data.evidence.escapeHTML() + '" significance="' + data.significance.escapeHTML() + '"> ';
  XML += '<conditions> ';

  if (isString(data.condition_type)) {
    XML += '<condition type="' + data.condition_type + '" ' + data.condition_target.sub(' ', '&nbsp;') + '="' + data.condition_text.escapeHTML() + '"/> ';
  }
  else {
    for (var i = 0; i < data.condition_type.length; i++) {
      XML += '<condition type="' + data.condition_type[i] + '" ' + data.condition_target[i].sub(' ', '') + '="' + data.condition_text[i].escapeHTML() + '"/> ';
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
  return false;
};
