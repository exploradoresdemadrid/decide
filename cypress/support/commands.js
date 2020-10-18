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

Cypress.Commands.add('fillOrganizationForm', (name) => {
  cy.visit('http://localhost:3000')
  cy.contains('Organizations').click()

  cy.contains('New Organization').click()
  cy.contains('Name').click().type(name)
})

Cypress.Commands.add('createOrganization', (name) => {
  cy.fillOrganizationForm(name)
  cy.contains('Crear Organization').click()

  cy.get('.alert.alert-info').should('contain', 'Organization was successfully created.')
})

Cypress.Commands.add('createVoting', (name, { status = 'draft' }) => {
  cy.contains('Nueva urna virtual').click()
  cy.contains('Title').click().type(name)
  cy.contains('Description').click().type('Sample description')
  cy.get('#voting_status').select(status)
  cy.get('#voting_timeout_in_seconds').select('1 minute')
  cy.contains('Enviar').click()

  cy.get('.alert.alert-info').should('contain', 'Voting was successfully created.')
})

Cypress.Commands.add('updateVotingStatus', (name, status) => {
  cy.visit('http://localhost:3000/')
  cy.contains(name).click()
  cy.wait(2000)
  cy.contains('Editar').click()
  cy.get('#voting_status').select(status)
  cy.contains('Enviar').click()
})

Cypress.Commands.add('createQuestion', (votingName, { title = 'Sample title', options = ['Yes', 'No'] }) => {
  cy.visit('http://localhost:3000/')
  cy.contains(votingName).click()
  cy.contains('a', 'Preguntas').click()
  cy.contains('Nueva pregunta').click()

  cy.contains('Title').click().type(title)

  options.forEach((optionTitle) => {
    cy.contains('Añadir opción').click()
    cy.get('fieldset fieldset:last-of-type input[type="text"]').click().type(optionTitle)
  })

  cy.contains('Enviar').click()
  cy.get('.alert.alert-info').should('contain', 'Question was successfully created.')
})

Cypress.Commands.add('loginAsGroup', (groupName) => {
  cy.get('#groups_index').contains('td', groupName).siblings(':nth-of-type(4)').first().invoke('text').then((authToken) => {
    cy.logout();
    cy.loginWithCode(authToken)
  })
})

Cypress.Commands.add('loginAsAdmin', () => {
  cy.visit('http://localhost:3000/users/sign_in')
  cy.login('admin_edm@example.com', '12345678')
})

Cypress.Commands.add('loginAsSecondAdmin', () => {
  cy.visit('http://localhost:3000/users/sign_in')
  cy.login('admin_sample@example.com', '12345678')
})

Cypress.Commands.add('loginAsSuperadmin', () => {
  cy.visit('http://localhost:3000/users/sign_in')
  cy.login('superadmin_edm@example.com', '12345678')
})

Cypress.Commands.add('loginWithCode', (authToken) => {
  cy.visit('http://localhost:3000')
  cy.get('#user_auth_token').type(authToken)
  cy.contains('Entrar').click()
})
