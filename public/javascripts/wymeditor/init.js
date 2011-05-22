jQuery(function() {
 $(".wymeditor").wymeditor({
        lang: 'ru', 
        stylesheet: '/stylesheets/main.css',
        postInitDialog: function(wym,wdw) {
                var body = wdw.document.body;
                
                $(body)                
                .filter('.wym_dialog_image').find('fieldset').eq(0)
                .after(wym.replaceStrings("<div id='imagegalery'></div>")); 
                $(body).find('#imagegalery').load('/admin/content_images/galery',
                 function(response) { 
                    $(body).find('a').click(function() {
                        $(body).find('input.wym_src').val($(this).attr('href'));
                        return false
                    });
                 });
                
            }
        });
 });
