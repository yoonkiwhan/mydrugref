document.observe('dom:loaded', function() {
    $$('#form_wrapper form')[0].observe('submit', function(e) {
        Event.stop(e);
        var form = $$('#form_wrapper form')[0];
        var data = form.serialize().parseQuery();
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
        
        submit(data.title, XML)
        }
    );
});

function appendToElement(field, from) {
    var oAjax=new Ajax.Updater(field, from, { insertion: Insertion.Bottom });
}

function isString() {
    if (typeof arguments[0] == 'string') return true;
    if (typeof arguments[0] == 'object') {
        var criterion = arguments[0].constructor.toString().match(/string/i); 
        return (criterion != null);  }return false;
}

function submit(name, body) {
    new Ajax.Request('/guidelines', {
        method: 'post',
        parameters: {'post[name]': name,
                     'post[body]': body}
    });
    window.location = "/guidelines";
}

function remove_fields(link) {
    $(link).previous('input[type=hidden]').value = '1';
    $(link).up('.fields').hide();
}
