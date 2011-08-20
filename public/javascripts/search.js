$(function() {
    $('.b-search-property a').click(function() {
        $(this).parent().find('.b-property-items').toggle();
        return false;   
     });

    $('.b-search-property :checkbox').live('click', function() {
     if ($(this).parent().parent().find('li input:checked').size() >0) {
       $(this).parentsUntil('#search_properties').find('a').addClass('has-selected-items');
     }
     else {
       $(this).parentsUntil('#search_properties').find('a').removeClass('has-selected-items');
     }     
    }); 
       
       
    $("#price_slider").slider({
        	range: true,
			min: 0,
			max: 10000,
			step:10,
			values: [ 1000, 3000 ],
			slide: function( event, ui ) {
			  input_elem_1 = $(this).parent().find(':text.value-from');
			  input_elem_2 = $(this).parent().find(':text.value-to');
			  if ( (ui.values[0] == ui.values[1]) && (ui.values[0] == 0) ) {
			    $(input_elem_1).val('по запросу');
			    $(input_elem_2).val('');
			  }
			  else {
  				$( input_elem_1 ).val( ui.values[ 0 ] );
  				$( input_elem_2 ).val( ui.values[ 1 ] );
				}
			}
		});
        
    $( "#store_count_slider" ).slider({
			range: false,
			min: 0,
			max: 1000,
			step:10,
			values: [ 100 ],
			slide: function( event, ui ) {
			  input_elem = $(this).parent().find(':text');
			  if ( (ui.values[0] == 0) ) {
			    $(input_elem).val('по запросу');
			  }
			  else {
  				$( input_elem ).val( ui.values[ 0 ] );
				}
			}
		});
		
		$( ".b-filter-slider :text" ).each(function(index) {
           slider = $(this).parentsUntil('.b-filter-slider').parent().find('.slider-range');
           val = 0;
		   if ( $(this).val() == "по запросу" ) 
             $(slider).slider({values: [0,0]});		           		    
		   else if ($(this).val().length > 0) {		   
		    if ( $(this).hasClass('value-from') ) {		
        	  $(slider).slider("values", 0, $(this).val());
		     } 
		    if ($(this).hasClass('value-to')) {
        	  $(slider).slider("values", 1, $(this).val());		      
		    }
		   } 

		});
});
