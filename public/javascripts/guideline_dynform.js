document.observe('dom:loaded', function() {
    $$('#form_wrapper form')[0].observe('submit', function(e) {
        Event.stop(e);
        var form = $$('#form_wrapper form')[0];
        var data = form.serialize().parseQuery();
        var method = Form.Element.getValue($('method'))
        if (method == 'update') {
          var uuid = Form.Element.getValue($('uuid'))
          var g_id = Form.Element.getValue($('g_id'))
        }
        else if (method == 'create') {
          var uuid = null
          var g_id = null
        }
        var XML = ''
        XML += '<guideline title="' + data.title + '" evidence="' + data.evidence + '" significance="' + data.significance + '"> ';
        XML += '<conditions> '

        if (isString(data.condition_type)) {
            if (data.destroy_condition == 0) {
                XML += '<condition type="' + data.condition_type + '" ' + data.condition_target + '="' + data.condition_text + '"/> '
            }
        }
        else {
            for (var i = 0; i < data.condition_type.length; i++) {
                if (data.destroy_condition[i] == 0) {
                    XML += '<condition type="' + data.condition_type[i] + '" ' + data.condition_target[i] + '="' + data.condition_text[i] + '"/> '
                }            
            }
        }
        XML += '</conditions> <consequence> '

        if (isString(data.warning_strength)) {
            if (data.destroy_consequence == 0) {
                XML += '<warning strength="' + data.warning_strength + '">' + data.warning_text + '</warning> '
            }
        }
        else {
            for (var j = 0; j < data.warning_strength.length; j++) {
                if (data.destroy_consequence[j] == 0) {
                    XML += '<warning strength="' + data.warning_strength[j] + '">' + data.warning_text[j] + '</warning> '
                }
            }
        }
        XML += '</consequence> </guideline>'

        submit(data.title, XML, uuid, g_id, method)
        }
    );
});

function appendToElement(field, from) {
    new Ajax.Updater(field, from, { insertion: Insertion.Bottom });
}

function isString() {
    if (typeof arguments[0] == 'string') return true;
    if (typeof arguments[0] == 'object') {
        var criterion = arguments[0].constructor.toString().match(/string/i); 
        return (criterion != null);  }return false;
}

function submit(name, body, uuid, g_id, method) {
    if (method == 'update') {
      var url = '/guidelines/' + g_id
      new Ajax.Request(url, {
          method: 'post',
          parameters: {'post[name]': name,
                       'post[body]': body,
                       'post[uuid]': uuid,
                       '_method': 'put'  }
      })
    }
    else if (method == 'create'){
      new Ajax.Request('/guidelines', {
          method: 'post',
          parameters: {'post[name]': name,
                       'post[body]': body}
      });
    }
}

function remove_fields(link) {
    $(link).previous('input[type=hidden]').value = '1';
    $(link).up('.fields').hide();
}