Feature: Casos dinamicos

  Background:
    * def responsetoken = call read('classpath:examples/booking/auth.feature@token-parameter') { user: "admin", pass: "password123"}
    * print responsetoken
    * def authtoken = "token=" + responsetoken.token
    Given url "https://restful-booker.herokuapp.com"

  Scenario: CP01-Partial Update Booking
    * def id = 1
    And path "booking/"+id
    And headers { Content-Type: "application/json", Accept: "application/json", Cookie: #(authtoken) }
    And request {"firstname" : "James","lastname" : "Brown"}
    When method PATCH
    Then status 200
    #falta validaciones

  Scenario Outline: CP02- Data dinamica csv
    And path "booking"
    And request
    """
    {
        "firstname" : <firstname>,
        "lastname" : <lastname>,
        "totalprice" : <totalprice>,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method post
    Then status 418

    Examples:
    |read('data.csv')|


  Scenario Outline: CP03- Data dinamica csv
    And path "booking"
    And request read('data-driven.json')
    When method post
    Then status 418

    Examples:
    |firstname| lastname|totalprice|depositpaid|
    |carlos   |zambrano |1234      |true       |
    |jose     |perez    |2345      |true       |
    |pepe     |suarez   |3456      |false      |



