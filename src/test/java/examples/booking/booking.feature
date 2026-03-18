Feature: Booking


  Scenario: CP01 - Filter booking by check
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking'
    And params {checkin: '2024-06-01', checkout: '2024-06-30'}
    When method get
    Then status 200

  Scenario:  CP03 - Ejemplo 2
    Given url 'https://restful-booker.herokuapp.com'
    And path '/booking'
    And params { firstname : "sally", lastname : "brown" }
    When method get
    Then status 200


  Scenario Outline: CP04 - Buscar booking con diferentes parametros
    Given url 'https://restful-booker.herokuapp.com'
    And path 'booking'
    And param firstname = '<firstname>'
    And param lastname = '<lastname>'
    When method get
    Then status 200
    Examples:
      | firstname | lastname |
      | Jim       | Brown    |
      | Susan     | Wilson   |
      | Mary      | Smith    |

  Scenario: CP03 - Get booking ids
    Given url "https://restful-booker.herokuapp.com"
    And path "/booking"
    And param firstname = "sally"
    And param lastname = "brown"
    When method get
    Then status 200

  Scenario: Cp03 - Booking
    Given url "https://restful-booker.herokuapp.com"
    And path "/booking"
    When method get
    Then status 200
    And match each response[*].bookingid == "#number"

  Scenario: CP05-getbookingId-OK
    * def id = 1
    Given url "https://restful-booker.herokuapp.com"
    And path "booking/" + id
    When method get
    Then status 418


  Scenario: CP05-getbookingId-OK-error
    * def id = 1
    Given url "https://restful-booker.herokuapp.com"
    And path "booking/" + id
    And header Accept = "string"
    When method get
    Then status 200
    And match response.firstname == "Sally"


  Scenario:  CP05 - Update Bookin
    Given url "https://restful-booker.herokuapp.com/"
    And path "/auth"
    And request {"username": "admin","password": "password123"}
    When method post
    Then status 200
    * def tokenAuth = response.token
    * print tokenAuth
    Given url "https://restful-booker.herokuapp.com/"
    And header Content-Type = "application/json"
    And header Accept = "application/json"
    And header Cookie = "token="+tokenAuth
    And path "/booking/1"
    And request
    """
        {
        "firstname" : "James",
        "lastname" : "Brown",
        "totalprice" : 111,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method put
    Then status 200


  Scenario: CP06-Create booking
    * def bodybooking = read('booking.json')
    Given url "https://restful-booker.herokuapp.com/"
    And path "booking"
    And request bodybooking
    When method post
    Then status 200
    And match response == read('schema.json')
    And match reponse.booking === bodybooking


  Scenario: CP07-Update booking con call
    * def responseToken = call read('classpath:examples/booking/auth.feature@token')
    * print responseToken
    * def tokenAuth = responseToken.token

    Given url "https://resful-booker.herokuapp.com/"
    And header Content-Type = "application/json"
    And header Accept = "application/json"
    And header Cookie = "token="+tokenAuth
    And path "/booking/1"
    And request
    """
        {
        "firstname" : "James",
        "lastname" : "Brown",
        "totalprice" : 111,
        "depositpaid" : true,
        "bookingdates" : {
            "checkin" : "2018-01-01",
            "checkout" : "2019-01-01"
        },
        "additionalneeds" : "Breakfast"
    }
    """
    When method put
    Then status 200