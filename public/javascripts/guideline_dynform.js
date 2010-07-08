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

function insert_drugs() {
  if ($(textbox).value.length > 0) {
    var codes = $(textbox).value.split("; ");
    var classes = $(textbox).next("#condition_detail").value.split("; ");
    var str = "";
    for (i=0; i < (codes.length - 1); i++) {
      str += "<li><span class='atc_code'>" + codes[i] + "</span>&nbsp;";
      str += "<span class='atc_class'>" + classes[i] + "</span>";
      str += "<a onclick=\"$(this).up('li').remove(); return false;\" href=\"#\">Remove from post</a></li>";
    };
    $('post_drug_refs').insert(str);
  };
};

function insertDrug() {
  var code_data = $$('.atc_code');
  var class_data = $$('.atc_class');
  var drug_codes = "";
  var drug_classes = "";

  for (i=0; i < code_data.length; i++) {
    drug_codes += code_data[i].firstChild.nodeValue + "; ";
    drug_classes += class_data[i].firstChild.nodeValue + "; ";
  }

  $(textbox).value = drug_codes;
  var next_box = $(textbox).next("#condition_detail");
  $(next_box).value = drug_classes;
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
    XML += '<condition type="' + data.condition_type + '" ' + data.condition_target + '="' + data.condition_text.escapeHTML() + '"/> ';
  }
  else {
    for (var i = 0; i < data.condition_type.length; i++) {
      XML += '<condition type="' + data.condition_type[i] + '" ' + data.condition_target[i] + '="' + data.condition_text[i].escapeHTML() + '"/> ';
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
