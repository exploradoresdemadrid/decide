/// <reference types="cypress" />

context('Group creation', () => {
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

    cy.contains('Nuevo grupo').click()
    cy.contains('Name').click().type('Sample name ' + uuid())
    cy.contains('Number').click().type('123')
    cy.contains('Available votes').click().type('5')
  })

  it('create group', () => {
    cy.contains('Enviar').click()

    cy.get('.alert.alert-info').should('contain', 'Group was successfully created.')
  })

  it('return an error when name is missing', () => {
    cy.get('#group_name').clear()
    cy.contains('Enviar').click()

    cy.get('span').should('contain', 'no puede estar en blanco')
  })

  it('return an error when available votes is 0', () => {
    cy.get('#group_available_votes').clear().type('0')
    cy.contains('Enviar').click()

    cy.get('span').should('contain', 'debe ser mayor que o igual a ')
  })
})
