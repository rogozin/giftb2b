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
    
    $( ".slider-range" ).slider({
			range: true,
			min: 0,
			max: 100000,
			step:100,
			values: [ 1000, 30000 ],
			slide: function( event, ui ) {
			  input_elem = $(this).parent().find(':text');
			  if ( (ui.values[0] == ui.values[1]) && (ui.values[0] == 0) ) {
			    $(input_elem).val('по запросу');
			  }
			  else {
  				$( input_elem ).val( ui.values[ 0 ] + "-" + ui.values[ 1 ] );
				}
			}
		});
		$( ".b-filter-slider :text" ).each(function(index) {
		  selected_values = $(this).val().split('-');		  
		  if (selected_values.length == 1 )
		    selected_values = [0, selected_values[0] > 0 ? selected_values[0] : 30000];
		    
		  if (selected_values.length > 2)
		    selected_values.length = 2;
		    
		  slider = $(this).parentsUntil('.b-filter-slider').parent().find('.slider-range');
		  $(slider).slider({values: selected_values.sort(function(a,b){return a-b})});
		});
});
