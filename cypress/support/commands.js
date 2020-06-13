Cypress.Commands.add('login', (email, password) => {
  cy.get('#user_email').type(email)
  cy.get('#user_password').type(password)
  cy.get('input').contains('Iniciar sesión').click()
})

Cypress.Commands.add('logout', () => {
  cy.contains('Cerrar sesión').click()
  cy.get('.alert.alert-info').should('contain', 'Sesión finalizada.')
})

Cypress.Commands.add('createGroup', (name) => {
  cy.fillGroupForm(name)
  cy.contains('Enviar').click()

  cy.get('.alert.alert-info').should('contain', 'Group was successfully created.')
})

Cypress.Commands.add('fillGroupForm', (name) => {
  cy.visit('http://localhost:3000')
  cy.contains('Grupos').click()

  cy.contains('Nuevo grupo').click()
  cy.contains('Name').click().type(name)
  cy.contains('Number').click().type('123')
  cy.contains('Available votes').click().type('5')
})

Cypress.Commands.add('loginAsGroup', (groupName) => {
  cy.get('table').contains('td', groupName).siblings(':nth-of-type(4)').first().invoke('text').then((authToken) => {
    cy.logout();
    cy.loginWithCode(authToken)
  })
})

Cypress.Commands.add('loginWithCode', (authToken) => {
  cy.visit('http://localhost:3000')
  cy.get('#user_auth_token').type(authToken)
  cy.contains('Entrar').click()
})
