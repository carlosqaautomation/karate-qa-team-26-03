Feature: Ejercicios Basicos

  Background:
    Given url 'https://petstore.swagger.io/v2'

  Scenario: CP01 - Login exitoso
    And path '/user/login'
    And param username = 'admin'
    And param password = '123456'
    When method get
    Then status 200

  Scenario: CP02 - Crear registro
    And path '/store/order'
    And request
    """
    {
      "id": 0,
      "petId": 123,
      "quantity": 5,
      "shipDate": "2026-02-25T01:59:47.470Z",
      "status": "placed",
      "complete": true
    }
    """
    When method post
    Then status 200

  Scenario: CP03 - Crear registro con variable

    * def bodyOrder =
    """
    {
      "id": 0,
      "petId": 123,
      "quantity": 5,
      "shipDate": "2026-02-25T01:59:47.470Z",
      "status": "placed",
      "complete": true
    }
    """
    And path "/store/order"

    And request bodyOrder
    When method post
    * print response
    * print 'Hola esta es una prueba: {}', response
    Then status 200


  Scenario: Prueba de assert
    # tipo de dato string
    * def color = 'red '

    # tipo de dato numero
    * def num = 5

    # 1     +     1 = 2 , '11'
    # '1  ' +'1' = '1  1'
    #suma 'red '+5 = red 5
    Then assert color + num == 'red 5'

  Scenario: CP04 - Actualizar informacion mascota
    And path '/pet'
    And request
    """
    {
      "id": 111,
      "category": {
        "id": 0,
        "name": "dog"
      },
      "name": "doggie",
      "photoUrls": [
        "string"
      ],
      "tags": [
        {
          "id": 0,
          "name": "mestizo"
        }
      ],
      "status": "available"
    }
    """
    When method put
    Then status 200
    And match response.category.name == 'dog'
    And match response.status == 'available'
    
    
  Scenario: CP05 - Buscar mascota por estado
    And path "/pet/findByStatus"
    And param status = "pending"
    When method get
    Then status 200
    * print response
    # recorrido de la lista de mascotas que su id sea de tipo number
    And match each response[*].id == '#number'
    And match each response[*].name == '#string'
    And match each response[*].status == 'sold'

  Scenario: CP06 - Buscar mascota por estado
    * def filter = "pending"
    And path "/pet/findByStatus"
    And param status = filter
    When method get
    Then status 200
    * print response
    # recorrido de la lista de mascotas que su id sea de tipo number
    And match each response[*].id == '#number'
    And match each response[*].name == '#string'
    And match each response[*].status == filter

