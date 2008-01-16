var PostForm = {
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