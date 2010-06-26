document.observe('dom:loaded', function() {
    $$('#form_wrapper form')[0].observe('submit', function(e) {
        //Event.stop(e); //For testing, to prevent saving to database
        var form = $$('#form_wrapper form')[0];
        var data = form.serialize().parseQuery();
        var XML = ''
        XML += '<guideline title="' + data.title + '" evidence="' + data.evidence + '" significance="' + data.significance + '"> ';
        XML += '<conditions> '

        if (isString(data.condition_type)) {
            XML += '<condition type="' + data.condition_type + '" ' + data.condition_target + '="' + data.condition_text + '"/> '    
        }
        else {
            for (var i = 0; i < data.condition_type.length; i++) {
                XML += '<condition type="' + data.condition_type[i] + '" ' + data.condition_target[i] + '="' + data.condition_text[i] + '"/> '    
            }
        }
        XML += '</conditions> <consequence> '

        if (isString(data.warning_type)) {
            XML += '<warning strength="' + data.warning_type + '">' + data.warning_text + '</warning> '    
        }
        else {
            for (var j = 0; j < data.warning_type.length; j++) {
                XML += '<warning strength="' + data.warning_type[j] + '">' + data.warning_text[j] + '</warning> '    
            }
        }
        XML += '</consequence> </guideline>'
        $('body').update(XML);
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

