Event.addBehavior({
  'a#hide_intro' :  Remote.Link({ onSuccess : function(e){
    $('intro').toggle();
  }}),
});