/// <reference types="cypress" />

context('Admin login', () => {
  const uuid = () => Cypress._.random(0, 1e6)

  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.login('admin@example.com', '12345678')
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
    cy.visit('http://localhost:3000')
    cy.contains('Grupos').click()
  })

  it('create group', () => {
    cy.contains('Nuevo grupo').click()
    cy.contains('Name').click().type('Sample name ' + uuid())
    cy.contains('Number').click().type('123')
    cy.contains('Available votes').click().type('5')
    cy.contains('Enviar').click()

    cy.get('.alert.alert-info').should('contain', 'Group was successfully created.')
  })
})
