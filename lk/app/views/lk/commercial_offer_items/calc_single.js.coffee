$("#<%= dom_id(@commercial_offer_item) %>").replaceWith("<%= escape_javascript render(:partial => 'lk/commercial_offers/co_item_row', :locals => {:item => @commercial_offer_item} ) %>")
$("#<%= dom_id(@commercial_offer_item) %> td.sum").effect('highlight', 2000)
$("#<%= dom_id(@commercial_offer_item) %> input:text").focus()
