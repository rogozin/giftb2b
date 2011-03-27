Feature: Show product store count

    In order to see the amount of goods in stock
    Logged user
    Should be admin or firm user
    
#    Scenario: Login
#    Given I am on the home page
#    When I login as "admin"
#    Then I should see "Администрирование"
    
    Scenario Outline: Show product_store
    Given I login as "<role>"
    And I visit the "product" category page
    Then I should <action> "Кол-во на складе: 100"
    
    Examples:
    |role        |action |
    |admin       |see    |
    |firm_manager|see    |
    |user        |not see|
#    
#    Scenario: Dont see product_store string
#    Given I login as "user"
#    And I visit the "product" category page
#    Then I should not see "Кол-во на складе: 100"    
