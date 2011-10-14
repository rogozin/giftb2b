$(function() {
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
});
