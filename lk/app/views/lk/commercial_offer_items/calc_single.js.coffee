$("#<%= dom_id(@commercial_offer_item) %>").replaceWith("<%= escape_javascript render(:partial => 'lk/commercial_offers/co_item_row', :locals => {:item => @commercial_offer_item} ) %>")
